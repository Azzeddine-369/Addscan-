import '../../domain/entities/additive.dart';
import '../../domain/repositories/additives_repository.dart';
import '../datasources/local_additives_datasource.dart';

class AdditivesRepositoryImpl implements AdditivesRepository {
  final LocalAdditivesDatasource localDatasource;

  AdditivesRepositoryImpl({required this.localDatasource});

  @override
  Future<void> initialize() async {
    await localDatasource.init();
  }

  @override
  Future<List<Additive>> getAllAdditives() async {
    await localDatasource.init();
    return localDatasource.getAll().map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Additive>> searchAdditives(String query) async {
    await localDatasource.init();
    return localDatasource.search(query).map((e) => e.toEntity()).toList();
  }

  @override
  Future<Additive?> getAdditiveByCode(String code) async {
    await localDatasource.init();
    return localDatasource.getByCode(code)?.toEntity();
  }

  @override
  Future<List<Additive>> getPopularAdditives() async {
    await localDatasource.init();
    return localDatasource.getPopular().map((e) => e.toEntity()).toList();
  }
}
