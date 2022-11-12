import 'package:fyp_chat_app/storage/secure_storage.dart';

import '../dto/login_dto.dart';

class CredentialStore {
  CredentialStore._();

  static final CredentialStore _instance = CredentialStore._();

  factory CredentialStore() {
    return _instance;
  }

  static const USERNAME_KEY = 'username_key';
  static const PASSWORD_KEY = 'password_key';

  Future<void> storeCredential(String username, String password) async {
    await SecureStorage().write(key: USERNAME_KEY, value: username);
    await SecureStorage().write(key: PASSWORD_KEY, value: password);
  }

  Future<LoginDto?> getCredential() async {
    String? username = await SecureStorage().read(key: USERNAME_KEY);
    String? password = await SecureStorage().read(key: PASSWORD_KEY);
    if (username == null || password == null) {
      return null;
    }
    return LoginDto(username: username, password: password);
  }

  Future<void> removeCredential() async {
    await SecureStorage().delete(key: USERNAME_KEY);
    await SecureStorage().delete(key: PASSWORD_KEY);
  }
}
