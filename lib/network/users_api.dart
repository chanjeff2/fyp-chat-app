import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:fyp_chat_app/models/user.dart';

import 'api.dart';

class UsersApi extends Api {
  // singleton
  UsersApi._();
  static final UsersApi _instance = UsersApi._();
  factory UsersApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/users";

  Future<User> getUserById(String id) async {
    final json = await get("/id/$id", useAuth: true);
    final dto = UserDto.fromJson(json);
    return User.fromDto(dto);
  }

  Future<User> getUserByUsername(String username) async {
    final json = await get("/username/$username", useAuth: true);
    final dto = UserDto.fromJson(json);
    return User.fromDto(dto);
  }
}
