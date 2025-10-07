import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product_model.dart';

class ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl = "http://10.0.2.2:5000/api/products";

  ProductRemoteDataSource(this.client);

  Future<ProductModel> addProduct({
    required int id,
    required String productName,
    required String quantity,
    required String livestockId,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'productName': productName,
        'quantity': quantity,
        'livestockId': livestockId,
      }),
    );
    print(response.body);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductModel.fromJson(data['product']);
    } else {
      throw data['message'] ?? 'Failed to add product';
    }
  }

  Future<List<ProductModel>> fetchProductsByLivestock(String livestockId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$livestockId'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) {
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else if (data['products'] != null) {
        return (data['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw data['message'] ?? 'Failed to fetch products';
    }
  }
}
