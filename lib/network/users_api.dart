import 'package:fyp_chat_app/models/create_user_dto.dart';
import 'package:http/http.dart' as http;

import 'api.dart';

class UsersApi extends Api {
  UsersApi._();

  static final UsersApi _instance = UsersApi._();

  @override
  String pathPrefix = "/users";

  factory UsersApi() {
    return _instance;
  }

  Future<void> registerUser(CreateUserDto createUserDto) async {
    var response = post("/", body: createUserDto.toJson());
    // throw UnimplementedError();
  }
}
