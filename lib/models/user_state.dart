import 'package:flutter/cupertino.dart';
import 'package:fyp_chat_app/dto/access_token_dto.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';

class UserState extends ChangeNotifier {
  AccountDto? _me;
  AccessTokenDto? _accessTokenDto;

  bool isInitialized = false;

  AccountDto? get me => _me;
  String? get accessToken => _accessTokenDto?.accessToken;
  bool get isLoggedIn => isInitialized && accessToken != null && me != null;

  UserState() {
    init();
  }

  Future<void> init() async {
    final credential = await CredentialStore().getCredential();
    if (credential != null) {
      try {
        final token = await AuthApi().login(credential);
        _accessTokenDto = token;
        final ac = await AccountApi().getMe(token.accessToken);
        _me = ac;
      } on ApiException catch (e) {
        // show error?
      }
    }
    isInitialized = true;
    notifyListeners();
  }

  void setMe(AccountDto? accountDto) {
    _me = accountDto;
    notifyListeners();
  }

  void setAccessToken(AccessTokenDto accessTokenDto) {
    _accessTokenDto = accessTokenDto;
    notifyListeners();
  }

  void clearState() {
    _me = null;
    _accessTokenDto = null;
    notifyListeners();
  }
}
