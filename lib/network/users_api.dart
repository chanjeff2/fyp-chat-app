import 'api.dart';

class UsersApi extends Api {
  UsersApi._();

  static final UsersApi _instance = UsersApi._();

  factory UsersApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/users";
}
