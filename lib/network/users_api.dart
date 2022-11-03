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

  Future<void> registerUser() async {
    // var response = post("/");
    throw UnimplementedError();
  }
}
