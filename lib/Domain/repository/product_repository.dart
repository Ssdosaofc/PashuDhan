
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ProductEntity> addProduct({
    required int id,
    required String productName,
    required String quantity,
    required String livestockId,
  });

  Future<List<ProductEntity>> fetchProductsByLivestock(String livestockId);
}
