import '../entities/additive.dart';
import '../entities/history_item.dart';
import '../entities/user_report.dart';

abstract class HistorySavedRepository {
  Future<List<HistoryItem>> getHistory();
  Future<List<HistoryItem>> getSaved();
  Future<void> addToHistory(Additive additive);
  Future<bool> toggleSave(Additive additive);
  Future<bool> isSaved(String additiveCode);
  Future<void> removeFromHistory(String id);
  Future<void> removeFromSaved(String additiveCode);
  Future<void> clearHistory();
  Future<void> saveUserReport(UserReport report);
}
