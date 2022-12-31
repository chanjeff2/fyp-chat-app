import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/storage/secure_storage.dart';

import '../dto/login_dto.dart';

class CredentialStore {
  // singleton
  CredentialStore._();
  static final CredentialStore _instance = CredentialStore._();
  factory CredentialStore() {
    return _instance;
  }

  static const usernameKey = 'username_key';
  static const passwordKey = 'password_key';
  static const accessTokenKey = 'access_token_key';
  static const refreshTokenKey = 'refresh_token_key';

  Future<void> storeCredential(String username, String password) async {
    await SecureStorage().write(key: usernameKey, value: username);
    await SecureStorage().write(key: passwordKey, value: password);
  }

  Future<void> storeToken(AccessTokenDto accessTokenDto) async {
    await SecureStorage()
        .write(key: accessTokenKey, value: accessTokenDto.accessToken);
    await SecureStorage()
        .write(key: refreshTokenKey, value: accessTokenDto.refreshToken);
  }

  Future<LoginDto?> getCredential() async {
    String? username = await SecureStorage().read(key: usernameKey);
    String? password = await SecureStorage().read(key: passwordKey);
    if (username == null || password == null) {
      return null;
    }
    return LoginDto(username: username, password: password);
  }

  Future<AccessTokenDto?> getToken() async {
    String? accessToken = await SecureStorage().read(key: accessTokenKey);
    String? refreshToken = await SecureStorage().read(key: refreshTokenKey);
    if (accessToken == null || refreshToken == null) {
      return null;
    }
    return AccessTokenDto(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> removeToken() async {
    await SecureStorage().delete(key: accessTokenKey);
  }

  Future<void> removeCredential() async {
    await SecureStorage().delete(key: usernameKey);
    await SecureStorage().delete(key: passwordKey);
    await SecureStorage().delete(key: accessTokenKey);
  }
}
