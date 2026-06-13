// lib/features/auth/domain/entities/session_entity.dart
//
// Magic Link session domain entity. Pure domain — no Hive, no Flutter.
// Represents a server-authenticated user session from Magic Link login.

class SessionEntity {
  final String userId;
  final String email;
  final String token;
  final DateTime expiresAt;
  final DateTime createdAt;

  const SessionEntity({
    required this.userId,
    required this.email,
    required this.token,
    required this.expiresAt,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration get remainingTtl => expiresAt.difference(DateTime.now());

  SessionEntity copyWith({
    String? userId,
    String? email,
    String? token,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return SessionEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          token == other.token;

  @override
  int get hashCode => userId.hashCode ^ token.hashCode;
}
