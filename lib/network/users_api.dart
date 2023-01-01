import '../dto/user_dto.dart';
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

  Future<UserDto> getUserById(String id) async {
    final json = await get("/id/$id", useAuth: true);
    return UserDto.fromJson(json);
  }

  Future<UserDto> getUserByUsername(String username) async {
    final json = await get("/username/$username", useAuth: true);
    return UserDto.fromJson(json);
  }
}
