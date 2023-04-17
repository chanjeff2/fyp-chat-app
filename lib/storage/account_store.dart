import 'dart:convert';

import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountStore {
  // singleton
  AccountStore._();
  static final AccountStore _instance = AccountStore._();
  factory AccountStore() {
    return _instance;
  }

  static const accountKey = 'account';

  Future<Account?> getAccount() async {
    final pref = await SharedPreferences.getInstance();
    final accountJson = pref.getString(accountKey);
    if (accountJson == null) {
      return null;
    }
    final dto = AccountDto.fromJson(json.decode(accountJson));
    return Account.fromDto(dto);
  }

  Future<void> storeAccount(AccountDto dto) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(accountKey, json.encode(dto.toJson()));
  }
}
