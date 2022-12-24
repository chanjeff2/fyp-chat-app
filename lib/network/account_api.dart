import 'package:fyp_chat_app/dto/account_dto.dart';

import 'api.dart';

class AccountApi extends Api {
  // singleton
  AccountApi._();
  static final AccountApi _instance = AccountApi._();
  factory AccountApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/account";

  Future<AccountDto> getMe() async {
    final json = await get("/me", useAuth: true);
    return AccountDto.fromJson(json);
  }
}
