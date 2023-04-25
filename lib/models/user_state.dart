import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/network/account_api.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:fyp_chat_app/utilities/sync_manager.dart';

class UserState extends ChangeNotifier {
  Account? _me;
  bool _isAccessTokenAvailable = false;
  bool isInitialized = false;

  Account? get me => _me;
  bool get isLoggedIn => isInitialized && _isAccessTokenAvailable && me != null;

  Chatroom? chatroom;

  final StreamController<ReceivedChatEvent> _messageStreamController =
      StreamController();

  late final Stream<ReceivedChatEvent> _messageStream;

  Stream<ReceivedChatEvent> get messageStream => _messageStream;
  StreamSink<ReceivedChatEvent> get messageSink =>
      _messageStreamController.sink;

  UserState() {
    _messageStream = _messageStreamController.stream.asBroadcastStream();
    init();
  }

  Future<void> init() async {
    final credential = await CredentialStore().getCredential();
    if (credential != null) {
      try {
        await AuthApi().login(credential);
        _isAccessTokenAvailable = true;
        final ac = await AccountApi().getMe();
        _me = ac;
        SignalClient().updateKeysIfNeeded(); // can be async
        await Future.wait([
          SyncManager().synchronizeContacts(),
          SyncManager().synchronizeGroups()
        ]);
      } on ApiException catch (e) {
        // show error?
      }
    }
    isInitialized = true;
    notifyListeners();
  }

  void setMe(Account? account) {
    _me = account;
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
