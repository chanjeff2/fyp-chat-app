import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen_group.dart';
import 'package:fyp_chat_app/screens/home/select_contact.dart';
import 'package:fyp_chat_app/screens/settings/settings_screen.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';
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
  final Map<String, Chatroom> _filteredChatroomMap = {};
  late final Future<bool> _loadChatroomFuture;
  late final StreamSubscription<ReceivedPlainMessage>
      _messageStreamSubscription;
  Offset _tapPosition = Offset.zero;
  List<Chatroom> chatroomListForDeleteToGestureDetector = [];
  int chatroomListForDeleteToGestureDetectorID = 0;

  final TextEditingController _keywordController = TextEditingController();
  bool _isSearching = false;

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
        _filteredChatroomMap[receivedMessage.chatroom.id] = receivedMessage.chatroom;
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
    _chatroomMap.clear();
    setState(() {
      _chatroomMap.addEntries(chatroomList.map((e) => MapEntry(e.id, e)));
    });
    return true;
  }

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          title: _isSearching 
                ? TextField(
                    enabled: true,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    controller: _keywordController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isCollapsed: true,
                      filled: true,
                      hintText: 'Search by chatroom name...',
                      hintStyle: TextStyle(color: Colors.grey.shade200),
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          setState(() {
                            _keywordController.text = "";
                            _filteredChatroomMap.clear();
                            _filteredChatroomMap.addAll(_chatroomMap);
                            _isSearching = false;
                          });
                        },
                      ),
                    ),
                    maxLines: 1,
                    onChanged: (text) {
                      setState(() {
                        _filteredChatroomMap.clear();
                        _filteredChatroomMap.addAll(_chatroomMap);
                        _filteredChatroomMap.removeWhere((key, value) =>
                                                          !(value.name.toLowerCase())
                                                          .contains(text.toLowerCase())
                                                        );
                      });
                    },
                  )
                : const Text("USTalk"),
          actions: _isSearching
          ? null
          : [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
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
          ]
        ),
        body: FutureBuilder<bool>(
          future: _loadChatroomFuture,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatroomList = _filteredChatroomMap.values.toList();
            chatroomList.sort((a, b) => a.compareByLastActivityTime(b) * -1);
            return ListView.builder(
              itemBuilder: (_, i) => GestureDetector(
                onTapDown: (position) => {_getTapPosition(position)},
                onLongPress: () async {
                  chatroomListForDeleteToGestureDetector = chatroomList;
                  chatroomListForDeleteToGestureDetectorID = i;
                  await _showContextMenu(context);
                },
                child: HomeContact(
                    chatroom: chatroomList[i],
                    onClick: () {
                      switch (chatroomList[i].type) {
                        case ChatroomType.oneToOne:
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ChatRoomScreen(
                                      chatroom: chatroomList[i])))
                              .then(
                                  (value) => setState(() => {_loadChatroom()}));
                          break;
                        case ChatroomType.group:
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ChatRoomScreenGroup(
                                      chatroom: chatroomList[i])))
                              .then(
                                  (value) => setState(() => {_loadChatroom()}));
                          break;
                      }
                    }),
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
                switch (chatroom.type) {
                  case ChatroomType.oneToOne:
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(chatroom: chatroom)))
                        .then((value) => setState(() => {_loadChatroom()}));
                    break;
                  case ChatroomType.group:
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) =>
                                ChatRoomScreenGroup(chatroom: chatroom)))
                        .then((value) => setState(() => {_loadChatroom()}));
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Bro what is this type, ${chatroom.type}?")));
                }
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
        Navigator.of(context)
            .push(_route(const SettingsScreen()))
            .then((value) => setState(() => {_loadChatroom()}));
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

  _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          PopupMenuItem(
            child: const Text('Delete chatroom'),
            onTap: () async {
              Future.delayed(
                const Duration(seconds: 0),
                () async {
                  String chatroomId = chatroomListForDeleteToGestureDetector[
                      chatroomListForDeleteToGestureDetectorID]
                  .id;
                  if (_chatroomMap[chatroomId]?.type == ChatroomType.oneToOne) {
                    //one to one chatroom deletion
                    bool status = await ChatroomStore().remove(chatroomId);
                    if (status) {
                      await MessageStore().removeAllMessageByChatroomId(chatroomId);
                      setState(() {
                        _chatroomMap.remove(chatroomId);
                      });
                    } else {
                      throw Exception(
                          'Chatroom already has been deleted or chatroom not found');
                    }
                  } else if (_chatroomMap[chatroomId]?.type == ChatroomType.group) {
                    //check whether the group is left, or blocked, if not, the user should not delete the group
                    if (true) {
                      //showdialog to alert user the group is not left or blocked
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title:
                                    const Text("Action failed"),
                                content: const Text(
                                    "Group chatrooms can only be deleted if you left or blocked the group."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ]);
                          });
                    } else {
                      //if the group is left or blocked, delete the group
                      bool status = await ChatroomStore().remove(chatroomId);
                      if (status) {
                        setState(() {
                          _chatroomMap.remove(chatroomId);
                        });
                      } else {
                        throw Exception(
                            'Chatroom already has been deleted or chatroom not found');
                      }
                    }
                  } else {
                    throw Exception('Chatroom type not found');
                  }
                }
              );
              
            },
            value: "Delete chatroom",
          ),
        ]);
  }
}
