import 'dart:io';

import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/storage/account_store.dart';

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

  Future<Account> getMe() async {
    final json = await get("/me", useAuth: true);
    final ac = AccountDto.fromJson(json);
    AccountStore().storeAccount(ac);
    return Account.fromDto(ac);
  }

  Future<Account> updateAccount(AccountDto accountDto) async {
    final json = await post("", body: accountDto.toJson(), useAuth: true);
    final ac = AccountDto.fromJson(json);
    AccountStore().storeAccount(ac);
    return Account.fromDto(ac);
  }

  Future<Account> updateProfile(AccountDto accountDto) async {
    final json = await patch("/update-profile",
        body: accountDto.toJson(), useAuth: true);
    final ac = AccountDto.fromJson(json);
    AccountStore().storeAccount(ac);
    return Account.fromDto(ac);
  }

  Future<Account> updateProfilePic(File image) async {
    final json = await putMedia("/update-profile-pic", file: image, useAuth: true, profilePic: true);
    final ac = AccountDto.fromJson(json);
    AccountStore().storeAccount(ac);
    return Account.fromDto(ac);
  }
}
