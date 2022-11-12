import 'package:fyp_chat_app/dto/account_dto.dart';

import 'api.dart';

class AccountApi extends Api {
  AccountApi._();

  static final AccountApi _instance = AccountApi._();

  factory AccountApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/account";

  Future<AccountDto> getMe(String accessToken) async {
    final json = await get("/me", bearerToken: accessToken);
    return AccountDto.fromJson(json);
  }
}
