import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/login_dto.dart';
import 'package:fyp_chat_app/dto/register_dto.dart';

import 'api.dart';

class AuthApi extends Api {
  AuthApi._();

  static final AuthApi _instance = AuthApi._();

  factory AuthApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/auth";

  Future<AccessTokenDto> register(RegisterDto registerDto) async {
    final json = await post("/register", body: registerDto.toJson());
    return AccessTokenDto.fromJson(json);
  }

  Future<AccessTokenDto> login(LoginDto loginDto) async {
    final json = await post("/login", body: loginDto.toJson());
    return AccessTokenDto.fromJson(json);
  }
}
