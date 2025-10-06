
import 'user_model.dart';
import 'product_model.dart';

class FarmerModel extends UserModel {
  final double lat;
  final double lng;
  final List<ProductModel> products;

  const FarmerModel({
    required String email,
    required String role,
    String? name,
    String? token,
    String? phoneNumber,
    required this.lat,
    required this.lng,
    required this.products,
  }) : super(email: email, role: role, name: name, token: token, phoneNumber: phoneNumber);

  factory FarmerModel.fromJson(Map<String, dynamic> json) {
    final List<ProductModel> products = (json['products'] as List?)
        ?.map((item) => ProductModel.fromJson(item))
        .toList() ??
        [];

    return FarmerModel(
      email: json['email'] ?? '',
      role: json['role'] ?? 'farmer',
      token: json['token'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      products: products,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base.addAll({
      'lat': lat,
      'lng': lng,
      'products': products.map((p) => p.toJson()).toList(),
    });
    return base;
  }
}
