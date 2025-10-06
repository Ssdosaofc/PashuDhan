
import '../../entities/product_entity.dart';
import '../../repository/product_repository.dart';

class FetchProductsUseCase {
  final ProductRepository repository;

  FetchProductsUseCase(this.repository);

  Future<List<ProductEntity>> call(int livestockId) async {
    return await repository.fetchProductsByLivestock(livestockId);
  }
}
