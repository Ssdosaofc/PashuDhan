import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Core/Constants/app_constants.dart';
import '../../models/animal_model.dart';
import '../local/local_datasource.dart';

class AnimalRemoteDataSource {
  final http.Client client;
  final baseUrl=AppConstants().baseUrl;
  final LocalDatasource localDatasource;

  AnimalRemoteDataSource(this.client, this.localDatasource);


  Future<AnimalModel> addAnimal(String name, String type) async {
    final token = await localDatasource.getAccessToken();
    final response = await client.post(
      Uri.parse("http://10.0.2.2:5000/api/animal/add"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'type': type}),
    );

    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");
    if (response.statusCode == 200) {
      print(response.body);
      return AnimalModel.fromJson(jsonDecode(response.body)['animal']);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to add';
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> getAnimals() async {
    final token = await localDatasource.getAccessToken();
    final response = await client.get(
      Uri.parse("http://10.0.2.2:5000/api/animal/my_animal"),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Status code: ${response.statusCode}");
    print("Body login: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final animals = (data['animals'] as List)
          .map((e) => AnimalModel.fromJson(e))
          .toList();
      final totalCount = data['totalCount'] as int;
      final monthlyCount = data['monthlyCount'] as int;
      return {'animals': animals, 'totalCount': totalCount, 'monthlyCount': monthlyCount};
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to fetch animals');
    }
  }

  Future<void> deleteAnimal(String animalId) async {
    final token = await localDatasource.getAccessToken();
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/api/animal/delete/$animalId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete animal');
    }
  }

  Future<List<String>> fetchAnimalIdsByName(String name) async {
    final token = await localDatasource.getAccessToken();
    if (token == null) throw Exception('No token found. Please login.');

    final url = Uri.parse('http://10.0.2.2:5000/api/animal/ids-by-name/$name');
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> idsDynamic = data['animalIds'] ?? [];
      final ids = idsDynamic.map((e) => e.toString()).toList();
      return ids;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      final body = response.body;
      throw Exception('Failed to fetch animal IDs: ${response.statusCode} $body');
    }
  }

}
