import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item_model.dart';
import '../../domain/entities/user_report.dart';

abstract class HistorySavedDatasource {
  Future<List<HistoryItemModel>> getHistory();
  Future<List<HistoryItemModel>> getSaved();
  Future<void> addToHistory(HistoryItemModel item);
  Future<bool> toggleSave(HistoryItemModel item);
  Future<bool> isSaved(String additiveCode);
  Future<void> removeFromHistory(String id);
  Future<void> removeFromSaved(String additiveCode);
  Future<void> clearHistory();
  Future<void> saveUserReport(UserReport report);
}

class HistorySavedDatasourceImpl implements HistorySavedDatasource {
  static const String _historyKey = 'addiscan_history_items_v1';
  static const String _savedKey = 'addiscan_saved_items_v1';
  static const String _reportsKey = 'addiscan_user_reports_v1';

  final SharedPreferences? _prefs;

  HistorySavedDatasourceImpl({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<List<HistoryItemModel>> getHistory() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_historyKey);
    if (raw == null) {
      // Seed initial items from design so the screen looks vibrant on first launch!
      final initial = _getInitialDesignHistory();
      await _saveHistoryList(prefs, initial);
      return initial;
    }
    try {
      final List<dynamic> list = json.decode(raw);
      return list.map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<HistoryItemModel>> getSaved() async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_savedKey);
    if (raw == null) {
      // Seed with E330 & E100 initially saved
      final initial = [
        HistoryItemModel(
          id: 'saved_e330',
          additiveCode: 'E330',
          additiveName: 'Citric Acid',
          safetyStatus: 'safe',
          iconType: 'lemon',
          timestampMs: DateTime.now().subtract(const Duration(hours: 4)).millisecondsSinceEpoch,
          isSaved: true,
        ),
        HistoryItemModel(
          id: 'saved_e100',
          additiveCode: 'E100',
          additiveName: 'Curcumin',
          safetyStatus: 'safe',
          iconType: 'curcumin',
          timestampMs: DateTime.now().subtract(const Duration(days: 3)).millisecondsSinceEpoch,
          isSaved: true,
        ),
      ];
      await _saveSavedList(prefs, initial);
      return initial;
    }
    try {
      final List<dynamic> list = json.decode(raw);
      return list.map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addToHistory(HistoryItemModel item) async {
    final prefs = await _getPrefs();
    final current = await getHistory();

    // Deduplicate by additiveCode
    current.removeWhere((e) => e.additiveCode.toUpperCase() == item.additiveCode.toUpperCase());
    current.insert(0, item);

    // Keep top 50
    if (current.length > 50) {
      current.removeRange(50, current.length);
    }

    await _saveHistoryList(prefs, current);
  }

  @override
  Future<bool> toggleSave(HistoryItemModel item) async {
    final prefs = await _getPrefs();
    final current = await getSaved();

    final index = current.indexWhere((e) => e.additiveCode.toUpperCase() == item.additiveCode.toUpperCase());
    bool nowSaved;
    if (index >= 0) {
      current.removeAt(index);
      nowSaved = false;
    } else {
      current.insert(0, item.copyWith(isSaved: true).toModel());
      nowSaved = true;
    }

    await _saveSavedList(prefs, current);
    return nowSaved;
  }

  @override
  Future<bool> isSaved(String additiveCode) async {
    final saved = await getSaved();
    return saved.any((e) => e.additiveCode.toUpperCase() == additiveCode.toUpperCase());
  }

  @override
  Future<void> removeFromHistory(String id) async {
    final prefs = await _getPrefs();
    final current = await getHistory();
    current.removeWhere((e) => e.id == id);
    await _saveHistoryList(prefs, current);
  }

  @override
  Future<void> removeFromSaved(String additiveCode) async {
    final prefs = await _getPrefs();
    final current = await getSaved();
    current.removeWhere((e) => e.additiveCode.toUpperCase() == additiveCode.toUpperCase());
    await _saveSavedList(prefs, current);
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await _getPrefs();
    await prefs.remove(_historyKey);
  }

  @override
  Future<void> saveUserReport(UserReport report) async {
    final prefs = await _getPrefs();
    final raw = prefs.getString(_reportsKey);
    List<dynamic> list = [];
    if (raw != null) {
      try {
        list = json.decode(raw);
      } catch (_) {}
    }
    list.add({
      'id': report.id,
      'additive_code': report.additiveCode,
      'reason': report.reason,
      'message': report.message,
      'email': report.email,
      'timestamp': report.timestamp.toIso8601String(),
    });
    await prefs.setString(_reportsKey, json.encode(list));
  }

  Future<void> _saveHistoryList(SharedPreferences prefs, List<HistoryItemModel> list) async {
    final encoded = json.encode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  Future<void> _saveSavedList(SharedPreferences prefs, List<HistoryItemModel> list) async {
    final encoded = json.encode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_savedKey, encoded);
  }

  List<HistoryItemModel> _getInitialDesignHistory() {
    final now = DateTime.now();
    return [
      HistoryItemModel(
        id: 'hist_e330',
        additiveCode: 'E330',
        additiveName: 'Citric Acid',
        safetyStatus: 'safe',
        iconType: 'lemon',
        timestampMs: now.subtract(const Duration(minutes: 45)).millisecondsSinceEpoch,
        isSaved: true,
      ),
      HistoryItemModel(
        id: 'hist_e621',
        additiveCode: 'E621',
        additiveName: 'Monosodium Glutamate',
        safetyStatus: 'caution',
        iconType: 'flask',
        timestampMs: now.subtract(const Duration(days: 1, hours: 2)).millisecondsSinceEpoch,
        isSaved: false,
      ),
      HistoryItemModel(
        id: 'hist_e150d',
        additiveCode: 'E150d',
        additiveName: 'Caramel Colour',
        safetyStatus: 'safe',
        iconType: 'droplet',
        timestampMs: now.subtract(const Duration(days: 2, hours: 7)).millisecondsSinceEpoch,
        isSaved: false,
      ),
      HistoryItemModel(
        id: 'hist_e100',
        additiveCode: 'E100',
        additiveName: 'Curcumin',
        safetyStatus: 'safe',
        iconType: 'curcumin',
        timestampMs: now.subtract(const Duration(days: 3, hours: 2)).millisecondsSinceEpoch,
        isSaved: true,
      ),
      HistoryItemModel(
        id: 'hist_e951',
        additiveCode: 'E951',
        additiveName: 'Aspartame',
        safetyStatus: 'caution',
        iconType: 'flask',
        timestampMs: now.subtract(const Duration(days: 5, hours: 9)).millisecondsSinceEpoch,
        isSaved: false,
      ),
    ];
  }
}

extension on HistoryItem {
  HistoryItemModel toModel() => HistoryItemModel.fromEntity(this);
}
