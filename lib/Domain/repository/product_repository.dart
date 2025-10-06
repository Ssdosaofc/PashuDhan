
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ProductEntity> addProduct({
    required int id,
    required String productName,
    required String quantity,
    required int livestockId,
  });

  Future<List<ProductEntity>> fetchProductsByLivestock(int livestockId);
}
