import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';
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
  static const accessTokenExpiresAtKey = 'access_token_expires_at_key';
  static const refreshTokenKey = 'refresh_token_key';
  static const refreshTokenExpiresAtKey = 'refresh_token_expires_at_key';

  Future<void> storeCredential(String username, String password) async {
    await SecureStorage().write(key: usernameKey, value: username);
    await SecureStorage().write(key: passwordKey, value: password);
  }

  Future<void> storeToken(AccessTokenDto accessTokenDto) async {
    await SecureStorage()
        .write(key: accessTokenKey, value: accessTokenDto.accessToken);
    await SecureStorage().write(
        key: accessTokenExpiresAtKey,
        value: accessTokenDto.accessTokenExpiresAt);
    if (accessTokenDto.refreshToken != null) {
      await SecureStorage()
          .write(key: refreshTokenKey, value: accessTokenDto.refreshToken);
    }
    if (accessTokenDto.refreshTokenExpiresAt != null) {
      await SecureStorage().write(
          key: refreshTokenExpiresAtKey,
          value: accessTokenDto.refreshTokenExpiresAt);
    }
  }

  Future<LoginDto?> getCredential() async {
    String? username = await SecureStorage().read(key: usernameKey);
    String? password = await SecureStorage().read(key: passwordKey);
    if (username == null || password == null) {
      return null;
    }
    return LoginDto(username: username, password: password);
  }

  Future<AccessToken?> getToken() async {
    String? accessToken = await SecureStorage().read(key: accessTokenKey);
    String? accessTokenExpiresAt =
        await SecureStorage().read(key: accessTokenExpiresAtKey);
    String? refreshToken = await SecureStorage().read(key: refreshTokenKey);
    String? refreshTokenExpiresAt =
        await SecureStorage().read(key: refreshTokenExpiresAtKey);
    if (accessToken == null || accessTokenExpiresAt == null) {
      return null;
    }
    return AccessToken.fromDto(AccessTokenDto(
      accessToken: accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt,
      refreshToken: refreshToken,
      refreshTokenExpiresAt: refreshTokenExpiresAt,
    ));
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
