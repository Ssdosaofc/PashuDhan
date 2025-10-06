class ProductModel {
  final int id;
  final String productName;
  final String quantity;
  final int livestockId;

  ProductModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.livestockId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      productName: json['productName'],
      quantity: json['quantity'],
      livestockId: json['livestockId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'livestockId': livestockId,
    };
  }
}
