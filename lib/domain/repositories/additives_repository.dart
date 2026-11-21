import '../entities/additive.dart';

abstract class AdditivesRepository {
  Future<void> initialize();
  Future<List<Additive>> getAllAdditives();
  Future<List<Additive>> searchAdditives(String query);
  Future<Additive?> getAdditiveByCode(String code);
  Future<List<Additive>> getPopularAdditives();
}
