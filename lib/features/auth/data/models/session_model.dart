// lib/features/auth/data/models/session_model.dart
//
// Hive-serializable Magic Link session. typeId: 9 — FIXED.
// Previous: 0-Transaction, 1-reserved, 2-Income, 3-FixedCost, 4-TransactionType,
//           5-Audit, 6-Analytics, 7-NudgePrefs, 8-NudgeLog

import 'package:hive/hive.dart';
import 'package:helm/features/auth/domain/entities/session_entity.dart';

part 'session_model.g.dart';

@HiveType(typeId: 9)
class SessionModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String token;

  @HiveField(3)
  final DateTime expiresAt;

  @HiveField(4)
  final DateTime createdAt;

  SessionModel({
    required this.userId,
    required this.email,
    required this.token,
    required this.expiresAt,
    required this.createdAt,
  });

  factory SessionModel.fromEntity(SessionEntity entity) => SessionModel(
        userId: entity.userId,
        email: entity.email,
        token: entity.token,
        expiresAt: entity.expiresAt,
        createdAt: entity.createdAt,
      );

  SessionEntity toEntity() => SessionEntity(
        userId: userId,
        email: email,
        token: token,
        expiresAt: expiresAt,
        createdAt: createdAt,
      );
}
