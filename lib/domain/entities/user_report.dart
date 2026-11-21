class UserReport {
  final String id;
  final String additiveCode;
  final String reason;
  final String message;
  final String? email;
  final DateTime timestamp;

  const UserReport({
    required this.id,
    required this.additiveCode,
    required this.reason,
    required this.message,
    this.email,
    required this.timestamp,
  });
}
