import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final int livestockId;
  const FetchProducts(this.livestockId);

  @override
  List<Object?> get props => [livestockId];
}

class AddProduct extends ProductEvent {
  final int id;
  final int livestockId;
  final String productName;
  final String quantity;

  const AddProduct({
    required this.id,
    required this.livestockId,
    required this.productName,
    required this.quantity,
  });

  @override
  List<Object?> get props => [livestockId, productName, quantity];
}
