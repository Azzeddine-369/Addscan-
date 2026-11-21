class HistoryItem {
  final String id;
  final String additiveCode;
  final String additiveName;
  final String safetyStatus;
  final String iconType;
  final DateTime timestamp;
  final bool isSaved;

  const HistoryItem({
    required this.id,
    required this.additiveCode,
    required this.additiveName,
    required this.safetyStatus,
    required this.iconType,
    required this.timestamp,
    this.isSaved = false,
  });

  HistoryItem copyWith({
    String? id,
    String? additiveCode,
    String? additiveName,
    String? safetyStatus,
    String? iconType,
    DateTime? timestamp,
    bool? isSaved,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      additiveCode: additiveCode ?? this.additiveCode,
      additiveName: additiveName ?? this.additiveName,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      iconType: iconType ?? this.iconType,
      timestamp: timestamp ?? this.timestamp,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
