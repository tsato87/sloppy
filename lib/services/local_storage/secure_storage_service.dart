import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> clearPassword() {
    return _secureStorage.write(key: 'userPassword', value: null);
  }

  Future<void> clearUserEmail() {
    return _secureStorage.write(key: 'userEmailAddress', value: null);
  }

  Future<String?> getPassword() {
    return _secureStorage.read(key: 'userPassword');
  }

  Future<String?> getUserEmail() {
    return _secureStorage.read(key: 'userEmailAddress');
  }

  Future<void> setPassword(String password) {
    return _secureStorage.write(key: 'userPassword', value: password);
  }

  Future<void> setUserEmail(String email) {
    return _secureStorage.write(key: 'userEmailAddress', value: email);
  }

}
