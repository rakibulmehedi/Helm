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
}
