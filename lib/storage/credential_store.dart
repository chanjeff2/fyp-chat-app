import 'dart:convert';

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

  Future<void> storeCredential(String username, String password) async {
    await SecureStorage().write(key: usernameKey, value: username);
    await SecureStorage().write(key: passwordKey, value: password);
  }

  Future<void> storeToken(AccessToken accessToken) async {
    final data = json.encode(accessToken.toDto().toJson());
    await SecureStorage().write(key: accessTokenKey, value: data);
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
    final data = await SecureStorage().read(key: accessTokenKey);
    if (data == null) {
      return null;
    }
    final decoded = json.decode(data);
    final dto = AccessTokenDto.fromJson(decoded);
    final token = AccessToken.fromDto(dto);
    return token;
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
