import '../../domain/entities/additive.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/entities/user_report.dart';
import '../../domain/repositories/history_saved_repository.dart';
import '../datasources/history_saved_datasource.dart';
import '../models/history_item_model.dart';

class HistorySavedRepositoryImpl implements HistorySavedRepository {
  final HistorySavedDatasource datasource;

  HistorySavedRepositoryImpl({required this.datasource});

  @override
  Future<List<HistoryItem>> getHistory() async {
    final list = await datasource.getHistory();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<HistoryItem>> getSaved() async {
    final list = await datasource.getSaved();
    return list.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addToHistory(Additive additive) async {
    final item = HistoryItemModel(
      id: 'hist_${additive.code.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
      additiveCode: additive.code,
      additiveName: additive.name,
      safetyStatus: additive.safetyStatus.name,
      iconType: additive.iconType,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      isSaved: await datasource.isSaved(additive.code),
    );
    await datasource.addToHistory(item);
  }

  @override
  Future<bool> toggleSave(Additive additive) async {
    final item = HistoryItemModel(
      id: 'saved_${additive.code.toLowerCase()}',
      additiveCode: additive.code,
      additiveName: additive.name,
      safetyStatus: additive.safetyStatus.name,
      iconType: additive.iconType,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      isSaved: true,
    );
    return await datasource.toggleSave(item);
  }

  @override
  Future<bool> isSaved(String additiveCode) async {
    return await datasource.isSaved(additiveCode);
  }

  @override
  Future<void> removeFromHistory(String id) async {
    await datasource.removeFromHistory(id);
  }

  @override
  Future<void> removeFromSaved(String additiveCode) async {
    await datasource.removeFromSaved(additiveCode);
  }

  @override
  Future<void> clearHistory() async {
    await datasource.clearHistory();
  }

  @override
  Future<void> saveUserReport(UserReport report) async {
    await datasource.saveUserReport(report);
  }
}
