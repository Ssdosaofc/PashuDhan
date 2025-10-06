
import '../../entities/product_entity.dart';
import '../../repository/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<ProductEntity> call({
    required int id,
    required String productName,
    required String quantity,
    required int livestockId,
  }) async {
    return await repository.addProduct(
      id: id,
      productName: productName,
      quantity: quantity,
      livestockId: livestockId,
    );
  }
}
