import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_additives_datasource.dart';
import '../../data/repositories/additives_repository_impl.dart';
import '../../domain/entities/additive.dart';
import '../../domain/repositories/additives_repository.dart';

final localAdditivesDatasourceProvider = Provider<LocalAdditivesDatasource>((ref) {
  return LocalAdditivesDatasourceImpl();
});

final additivesRepositoryProvider = Provider<AdditivesRepository>((ref) {
  final ds = ref.watch(localAdditivesDatasourceProvider);
  return AdditivesRepositoryImpl(localDatasource: ds);
});

final popularAdditivesProvider = FutureProvider<List<Additive>>((ref) async {
  final repo = ref.watch(additivesRepositoryProvider);
  return repo.getPopularAdditives();
});

final allAdditivesProvider = FutureProvider<List<Additive>>((ref) async {
  final repo = ref.watch(additivesRepositoryProvider);
  return repo.getAllAdditives();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Additive>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final repo = ref.watch(additivesRepositoryProvider);
  return repo.searchAdditives(query);
});

final additiveDetailsProvider = FutureProvider.family<Additive?, String>((ref, code) async {
  final repo = ref.watch(additivesRepositoryProvider);
  return repo.getAdditiveByCode(code);
});
