import '../../Domain/entities/product_entity.dart';
import '../../Domain/repository/product_repository.dart';
import '../datasource/remote/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductEntity> addProduct({
    required int id,
    required String productName,
    required String quantity,
    required int livestockId,
  }) async {
    final model = await remoteDataSource.addProduct(
      id: id,
      productName: productName,
      quantity: quantity,
      livestockId: livestockId,
    );

    return ProductEntity(
      id: model.id,
      productName: model.productName,
      quantity: model.quantity,
      livestockId: model.livestockId,
    );
  }

  @override
  Future<List<ProductEntity>> fetchProductsByLivestock(int livestockId) async {
    final models = await remoteDataSource.fetchProductsByLivestock(livestockId);
    return models
        .map((m) => ProductEntity(
      id: m.id,
      productName: m.productName,
      quantity: m.quantity,
      livestockId: m.livestockId,
    ))
        .toList();
  }
}
