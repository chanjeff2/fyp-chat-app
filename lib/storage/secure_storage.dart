import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static final SecureStorage _instance = SecureStorage._();

  factory SecureStorage() {
    return _instance;
  }

  final _storage = const FlutterSecureStorage();

  Future<String?> read({required String key}) async {
    return await _storage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> write({required String key, required String? value}) async {
    return await _storage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> delete({required String key}) async {
    return await _storage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll(
      aOptions: _getAndroidOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
