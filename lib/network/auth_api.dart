import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/dto/register_dto.dart';
import 'package:fyp_chat_app/models/access_token.dart';

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
    return AccessToken.fromDto(dto);
  }

  Future<AccessToken> login(LoginDto loginDto) async {
    final json = await post("/login", body: loginDto.toJson());
    final dto = AccessTokenDto.fromJson(json);
    return AccessToken.fromDto(dto);
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
    return AccessToken.fromDto(dto);
  }
}
