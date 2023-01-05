import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fyp_chat_app/dto/account_dto.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';

class UserState extends ChangeNotifier {
  AccountDto? _me;
  bool _isAccessTokenAvailable = false;
  bool isInitialized = false;

  AccountDto? get me => _me;
  bool get isLoggedIn => isInitialized && _isAccessTokenAvailable && me != null;

  User? chattingWith;

  final StreamController<PlainMessage> _messageStreamController =
      StreamController();

  late final Stream<PlainMessage> _messageStream;

  Stream<PlainMessage> get messageStream => _messageStream;
  StreamSink<PlainMessage> get messageSink => _messageStreamController.sink;

  UserState() {
    _messageStream = _messageStreamController.stream.asBroadcastStream();
    init();
  }

  Future<void> init() async {
    final credential = await CredentialStore().getCredential();
    if (credential != null) {
      try {
        final token = await AuthApi().login(credential);
        await CredentialStore().storeToken(token);
        _isAccessTokenAvailable = true;
        final ac = await AccountApi().getMe();
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

  void setAccessTokenStatus(bool isAvailable) {
    _isAccessTokenAvailable = isAvailable;
    notifyListeners();
  }

  void clearState() {
    _me = null;
    _isAccessTokenAvailable = false;
    notifyListeners();
  }
}
