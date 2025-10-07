import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../Core/Constants/strings_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasource {
  final FlutterSecureStorage _secureStorage;
  final sharedPreferences = SharedPreferences.getInstance();


  LocalDatasource({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<bool> get isUserAuthenticated async =>
      (await _secureStorage.read(key: StringConstants.token)) != null;

  Future<String?> getAccessToken() async =>
      await _secureStorage.read(key: StringConstants.token);

  Future<void> writeAccessToken(String token) async =>
      await _secureStorage.write(key: StringConstants.token, value: token);

  Future<void> clearAccessToken() async =>
      await _secureStorage.delete(key: StringConstants.token);

  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> writeInt({required String key, required int value}) async{
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<void> writeBoolean({
    required String key,
    required bool value,
  }) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<String?> getData(String key) async =>
      await _secureStorage.read(key: key);

  Future<int?> getIntData(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  Future<bool?> getBoolean(String key) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  Future<void> clearAllData() async {
    await _secureStorage.deleteAll();
  }
}