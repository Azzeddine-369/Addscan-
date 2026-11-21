import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/history_saved_datasource.dart';
import '../../data/repositories/history_saved_repository_impl.dart';
import '../../domain/entities/additive.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/entities/user_report.dart';
import '../../domain/repositories/history_saved_repository.dart';

final historySavedDatasourceProvider = Provider<HistorySavedDatasource>((ref) {
  return HistorySavedDatasourceImpl();
});

final historySavedRepositoryProvider = Provider<HistorySavedRepository>((ref) {
  final ds = ref.watch(historySavedDatasourceProvider);
  return HistorySavedRepositoryImpl(datasource: ds);
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<HistoryItem>>> {
  final HistorySavedRepository repository;

  HistoryNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final items = await repository.getHistory();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> recordVisit(Additive additive) async {
    await repository.addToHistory(additive);
    await loadHistory();
  }

  Future<void> removeItem(String id) async {
    await repository.removeFromHistory(id);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((e) => e.id != id).toList());
  }

  Future<void> clearAll() async {
    await repository.clearHistory();
    state = const AsyncValue.data([]);
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<HistoryItem>>>((ref) {
  final repo = ref.watch(historySavedRepositoryProvider);
  return HistoryNotifier(repo);
});

class SavedNotifier extends StateNotifier<AsyncValue<List<HistoryItem>>> {
  final HistorySavedRepository repository;

  SavedNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadSaved();
  }

  Future<void> loadSaved() async {
    state = const AsyncValue.loading();
    try {
      final items = await repository.getSaved();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> toggleSave(Additive additive) async {
    final isSaved = await repository.toggleSave(additive);
    await loadSaved();
    return isSaved;
  }

  Future<void> removeSaved(String additiveCode) async {
    await repository.removeFromSaved(additiveCode);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(current.where((e) => e.additiveCode.toUpperCase() != additiveCode.toUpperCase()).toList());
  }
}

final savedNotifierProvider =
    StateNotifierProvider<SavedNotifier, AsyncValue<List<HistoryItem>>>((ref) {
  final repo = ref.watch(historySavedRepositoryProvider);
  return SavedNotifier(repo);
});

final isAdditiveSavedProvider = FutureProvider.family<bool, String>((ref, code) async {
  // Watch savedNotifierProvider to reactively update bookmark icon!
  final savedList = ref.watch(savedNotifierProvider).valueOrNull ?? [];
  return savedList.any((e) => e.additiveCode.toUpperCase() == code.toUpperCase());
});

final filterStatusProvider = StateProvider<String>((ref) => 'all');
final filterQueryProvider = StateProvider<String>((ref) => '');

final userReportProvider = Provider<Future<void> Function(UserReport)>((ref) {
  final repo = ref.watch(historySavedRepositoryProvider);
  return (report) => repo.saveUserReport(report);
});
