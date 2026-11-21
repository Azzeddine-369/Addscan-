import '../../domain/entities/history_item.dart';

class HistoryItemModel {
  final String id;
  final String additiveCode;
  final String additiveName;
  final String safetyStatus;
  final String iconType;
  final int timestampMs;
  final bool isSaved;

  const HistoryItemModel({
    required this.id,
    required this.additiveCode,
    required this.additiveName,
    required this.safetyStatus,
    required this.iconType,
    required this.timestampMs,
    this.isSaved = false,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      id: json['id'] as String? ?? '',
      additiveCode: json['additive_code'] as String? ?? '',
      additiveName: json['additive_name'] as String? ?? '',
      safetyStatus: json['safety_status'] as String? ?? 'safe',
      iconType: json['icon_type'] as String? ?? 'flask',
      timestampMs: json['timestamp_ms'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      isSaved: json['is_saved'] == 1 || json['is_saved'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'additive_code': additiveCode,
      'additive_name': additiveName,
      'safety_status': safetyStatus,
      'icon_type': iconType,
      'timestamp_ms': timestampMs,
      'is_saved': isSaved ? 1 : 0,
    };
  }

  HistoryItem toEntity() {
    return HistoryItem(
      id: id,
      additiveCode: additiveCode,
      additiveName: additiveName,
      safetyStatus: safetyStatus,
      iconType: iconType,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMs),
      isSaved: isSaved,
    );
  }

  factory HistoryItemModel.fromEntity(HistoryItem entity) {
    return HistoryItemModel(
      id: entity.id,
      additiveCode: entity.additiveCode,
      additiveName: entity.additiveName,
      safetyStatus: entity.safetyStatus,
      iconType: entity.iconType,
      timestampMs: entity.timestamp.millisecondsSinceEpoch,
      isSaved: entity.isSaved,
    );
  }
}
