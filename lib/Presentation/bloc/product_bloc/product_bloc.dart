import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/usecases/product_usecases/add_product_usecase.dart';
import '../../../Domain/usecases/product_usecases/fetch_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProductUseCase addProductUseCase;
  final FetchProductsUseCase fetchProductsUseCase;

  ProductBloc({
    required this.addProductUseCase,
    required this.fetchProductsUseCase,
  }) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<AddProduct>(_onAddProduct);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await fetchProductsUseCase(event.livestockId);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await addProductUseCase(
        id: event.id,
        productName: event.productName,
        quantity: event.quantity,
        livestockId: event.livestockId,
      );
      // Fetch updated list after adding
      final products = await fetchProductsUseCase(event.livestockId);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
