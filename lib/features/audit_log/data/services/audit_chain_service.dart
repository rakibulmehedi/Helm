// lib/features/audit_log/data/services/audit_chain_service.dart
//
// Minimal tamper-evidence chain for audit events.
// Stores a SHA-256 chain hash keyed by event id in a dedicated Hive box.
// Each hash = SHA256(previousHash + canonical event payload). Corruption of
// any event or reordering changes the terminal hash detectably.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

class AuditChainService {
  static const String _lastHashKey = 'last_hash';

  Box<String>? _box;

  Future<Box<String>> get _chainBox async {
    if (_box != null && _box!.isOpen) return _box!;
    if (!Hive.isBoxOpen(AppBoxNames.auditChainBox)) {
      _box = await Hive.openBox<String>(AppBoxNames.auditChainBox);
    } else {
      _box = Hive.box<String>(AppBoxNames.auditChainBox);
    }
    return _box!;
  }

  /// Computes the chain hash for [event] and stores it keyed by event id.
  /// Also stores the previous hash under a companion key for later retrieval.
  /// Returns the hash string or null if the chain box cannot be opened.
  Future<String?> appendAndHash(AuditEvent event) async {
    try {
      final box = await _chainBox;
      final previousHash = box.get(_lastHashKey) ?? '';
      final payload = _canonicalPayload(event, previousHash);
      final hash = sha256.convert(utf8.encode(payload)).toString();
      await box.put(event.id, hash);
      await box.put('${event.id}_prev', previousHash);
      await box.put(_lastHashKey, hash);
      return hash;
    } on Exception catch (_) {
      return null;
    }
  }

  /// Returns the stored hash for [eventId], or null if missing.
  Future<String?> hashFor(String eventId) async {
    try {
      final box = await _chainBox;
      return box.get(eventId);
    } on Exception catch (_) {
      return null;
    }
  }

  /// Returns the previous hash that was chained into [eventId]'s hash.
  /// Returns empty string for genesis events (first in chain) or unknown IDs.
  Future<String> previousHashFor(String eventId) async {
    try {
      final box = await _chainBox;
      return box.get('${eventId}_prev', defaultValue: '') as String;
    } on Exception catch (_) {
      return '';
    }
  }

  /// Returns the terminal hash of the chain, or an empty string for an empty
  /// chain.
  Future<String> terminalHash() async {
    try {
      final box = await _chainBox;
      return box.get(_lastHashKey) ?? '';
    } on Exception catch (_) {
      return '';
    }
  }

  /// Clears the chain. Used during account deletion.
  Future<void> clear() async {
    try {
      final box = await _chainBox;
      await box.clear();
    } on Exception catch (_) {
      // Best-effort; deletion must continue.
    }
  }

  /// Canonical payload used for hashing. Order and field names must stay stable.
  String _canonicalPayload(AuditEvent event, String previousHash) {
    final buffer = StringBuffer()
      ..write(previousHash)
      ..write('|')
      ..write(event.id)
      ..write('|')
      ..write(event.timestamp.millisecondsSinceEpoch)
      ..write('|')
      ..write(event.eventType.index)
      ..write('|')
      ..write(event.entityType.index)
      ..write('|')
      ..write(event.entityId)
      ..write('|')
      ..write(event.previousValue ?? '')
      ..write('|')
      ..write(event.newValue ?? '')
      ..write('|')
      ..write(event.description);
    return buffer.toString();
  }

  /// Recomputes the chain over [eventsNewestFirst] and compares each event's
  /// recomputed hash against the stored hash.
  ///
  /// Assumes events were appended in ascending-timestamp order (true in
  /// practice — every event is appended at creation time), so reversing to
  /// oldest-first reconstructs the original append order and chain.
  /// Re-uses [_canonicalPayload] so verification and append stay in lockstep.
  /// Any storage failure is surfaced as a non-intact result, never thrown.
  Future<ChainVerification> verifyChain(
    List<AuditEvent> eventsNewestFirst,
  ) async {
    if (eventsNewestFirst.isEmpty) {
      return const ChainVerification(isIntact: true, verifiedCount: 0);
    }
    try {
      final box = await _chainBox;
      final chronological = eventsNewestFirst.reversed.toList();
      var previousHash = '';
      var verified = 0;
      for (final event in chronological) {
        final payload = _canonicalPayload(event, previousHash);
        final recomputed = sha256.convert(utf8.encode(payload)).toString();
        final stored = box.get(event.id);
        if (stored == null || stored != recomputed) {
          return ChainVerification(
            isIntact: false,
            verifiedCount: verified,
            firstBrokenEventId: event.id,
          );
        }
        previousHash = recomputed;
        verified++;
      }
      // Confirm the terminal hash matches the last recomputed hash.
      final terminal = box.get(_lastHashKey) ?? '';
      if (terminal != previousHash) {
        return ChainVerification(
          isIntact: false,
          verifiedCount: verified,
          firstBrokenEventId: chronological.last.id,
        );
      }
      return ChainVerification(isIntact: true, verifiedCount: verified);
    } on Exception catch (_) {
      return const ChainVerification(
        isIntact: false,
        verifiedCount: 0,
        firstBrokenEventId: null,
      );
    }
  }
}

/// Result of re-verifying the audit hash chain.
class ChainVerification {
  /// True when every recomputed hash matches the stored hash.
  final bool isIntact;

  /// id of the first event whose recomputed hash != stored hash; null if intact.
  final String? firstBrokenEventId;

  /// Number of events that were verified before stopping (or all, if intact).
  final int verifiedCount;

  const ChainVerification({
    required this.isIntact,
    required this.verifiedCount,
    this.firstBrokenEventId,
  });
}
