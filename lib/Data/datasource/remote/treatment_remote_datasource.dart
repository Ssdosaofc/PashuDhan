
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pashu_dhan/Data/datasource/local/local_datasource.dart';
import '../../models/treatment_model.dart';



class TreatmentRemoteDatasource {
  final http.Client client;
  final LocalDatasource localDatasource;
  TreatmentRemoteDatasource(this.client,this.localDatasource);


  Future<TreatmentModel> addTreatment(TreatmentModel treatment) async {
    final token = await localDatasource.getAccessToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/treatment/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(treatment.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['treatment'];
      return TreatmentModel.fromJson(data);
    } else {
      throw Exception('Failed to add treatment');
    }
  }

  Future<List<TreatmentModel>> getTreatmentsByAnimal(String animal) async {
    final token = await localDatasource.getAccessToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/treatment/by-animal/$animal'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['treatments'] as List;
      return data.map((t) => TreatmentModel.fromJson(t)).toList();
    } else {
      throw Exception('Failed to fetch treatments');
    }
  }
  Future<List<TreatmentModel>> getAllTreatments() async {
    final token = await localDatasource.getAccessToken();
  final response = await http.get(
    Uri.parse('http://10.0.2.2:5000/api/treatment/my_treatments'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['treatments'] as List;
      return data.map((t) => TreatmentModel.fromJson(t)).toList();
    } else {
      throw Exception('Failed to fetch treatments');
    }
  }





}
