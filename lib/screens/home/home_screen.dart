import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/home/select_contact.dart';
import 'package:fyp_chat_app/screens/settings/settings_screen.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:fyp_chat_app/storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var appBarHeight = AppBar().preferredSize.height;
  final Map<String, Chatroom> _chatroomMap = {};
  late final Future<bool> _loadChatroomFuture;
  late final StreamSubscription<ReceivedPlainMessage>
      _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    _loadChatroomFuture = _loadChatroom();
    _messageStreamSubscription = Provider.of<UserState>(context, listen: false)
        .messageStream
        .listen((receivedMessage) {
      setState(() {
        // update contact on receive new message
        _chatroomMap[receivedMessage.chatroom.id] = receivedMessage.chatroom;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageStreamSubscription.cancel();
  }

  Future<bool> _loadChatroom() async {
    final chatroomList = await ChatroomStore().getAllChatroom();
    setState(() {
      _chatroomMap.addEntries(chatroomList.map((e) => MapEntry(e.id, e)));
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          title: const Text("USTalk"),
          actions: [
            IconButton(
              onPressed: () {
                print("Search - To be implemented");
              },
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton(
              offset: Offset(0.0, appBarHeight),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              onSelected: (value) {
                _onMenuItemSelected(value as int, userState);
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem('Settings', Icons.settings, 0),
                _buildPopupMenuItem('Logout', Icons.logout, 1),
              ],
            ),
          ],
        ),
        body: FutureBuilder<bool>(
          future: _loadChatroomFuture,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatroomList = _chatroomMap.values.toList();
            chatroomList.sort((a, b) => a.compareByLastActivityTime(b) * -1);
            return ListView.builder(
              itemBuilder: (_, i) => HomeContact(
                chatroom: chatroomList[i],
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ChatRoomScreen(chatroom: chatroomList[i])));
                },
              ),
              itemCount: chatroomList.length,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(_route(SelectContact(
              onNewChatroom: (chatroom) {
                setState(() {
                  _chatroomMap[chatroom.id] = chatroom;
                });
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatRoomScreen(chatroom: chatroom)));
              },
            )));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Route _route(Widget screen) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  /* Codes of handling more menu items here */
  // Create a popup menu item that is in the form of Icon + text
  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int positon) {
    return PopupMenuItem(
      value: positon,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value, UserState userState) async {
    switch (value) {
      case 0:
        Navigator.of(context).push(_route(const SettingsScreen()));
        break;
      case 1:
        try {
          await DevicesApi().removeDevice();
          await AuthApi().logout();
        } catch (e) {
          // nothing I can do
        }
        await CredentialStore().removeCredential();
        await DiskStorage().deleteDatabase();
        await SecureStorage().deleteAll();
        await (await SharedPreferences.getInstance()).clear();
        userState.clearState();
        break;
    }
  }
}
