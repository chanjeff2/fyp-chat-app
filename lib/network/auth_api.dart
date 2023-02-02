import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/dto/register_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';

import 'api.dart';

class AuthApi extends Api {
  // singleton
  AuthApi._();
  static final AuthApi _instance = AuthApi._();
  factory AuthApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/auth";

  Future<AccessToken> register(RegisterDto registerDto) async {
    final json = await post("/register", body: registerDto.toJson());
    final dto = AccessTokenDto.fromJson(json);
    final accessToken = AccessToken.fromDto(dto);
    // store credential
    await CredentialStore()
        .storeCredential(registerDto.username, registerDto.password);
    await CredentialStore().storeToken(accessToken);
    return accessToken;
  }

  Future<AccessToken> login(LoginDto loginDto) async {
    final json = await post("/login", body: loginDto.toJson());
    final dto = AccessTokenDto.fromJson(json);
    final accessToken = AccessToken.fromDto(dto);
    // store credential
    await CredentialStore()
        .storeCredential(loginDto.username, loginDto.password);
    await CredentialStore().storeToken(accessToken);
    return accessToken;
  }

  Future<void> logout() async {
    await post("/logout", useAuth: true);
  }

  Future<AccessToken> refreshToken(String refreshToken) async {
    final json = await post(
      "/refresh-tokens",
      headers: {'Authorization': 'Bearer $refreshToken'},
    );
    final dto = AccessTokenDto.fromJson(json);
    final accessToken = AccessToken.fromDto(dto);
    await CredentialStore().storeToken(accessToken);
    return accessToken;
  }
}
