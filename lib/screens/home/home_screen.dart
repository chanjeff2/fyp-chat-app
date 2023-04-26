import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/access_change_event.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/network/block_api.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen_group.dart';
import 'package:fyp_chat_app/screens/home/select_contact.dart';
import 'package:fyp_chat_app/screens/settings/settings_screen.dart';
import 'package:fyp_chat_app/storage/block_store.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:fyp_chat_app/storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  var appBarHeight = AppBar().preferredSize.height;
  final Map<String, Chatroom> _chatroomMap = {};
  final Map<String, Chatroom> _filteredChatroomMap = {};
  late Future<bool> _loadChatroomFuture;
  late final StreamSubscription<ReceivedChatEvent> _messageStreamSubscription;
  Offset _tapPosition = Offset.zero;
  List<Chatroom> chatroomListForDeleteToGestureDetector = [];
  int chatroomListForDeleteToGestureDetectorID = 0;

  final TextEditingController _keywordController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _loadChatroomFuture = _loadChatroom();
    _messageStreamSubscription = Provider.of<UserState>(context, listen: false)
        .messageStream
        .listen((receivedMessage) {
      switch (receivedMessage.event.type) {
        case FCMEventType.textMessage:
        case FCMEventType.mediaMessage:
        case FCMEventType.patchGroup:
        case FCMEventType.addMember:
        case FCMEventType.promoteAdmin:
        case FCMEventType.demoteAdmin:
        case FCMEventType.memberJoin:
        case FCMEventType.memberLeave: // me leave handled onClick
          setState(() {
            // update contact on receive new message
            _chatroomMap[receivedMessage.chatroom.id] =
                receivedMessage.chatroom;
            _filteredChatroomMap[receivedMessage.chatroom.id] =
                receivedMessage.chatroom;
          });
          break;
        case FCMEventType.kickMember:
          final me = Provider.of<UserState>(context, listen: false).me!;
          final event = receivedMessage.event as AccessControlEvent;
          if (me.id == event.targetUserId) {
            // I got kicked
            setState(() {
              _chatroomMap.remove(receivedMessage.chatroom.id);
              _filteredChatroomMap.remove(receivedMessage.chatroom.id);
            });
          }
          break;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    _messageStreamSubscription.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      _loadChatroomFuture = _loadChatroom();
    }
  }

  Future<bool> _loadChatroom() async {
    final chatroomList = await ChatroomStore().getAllChatroom();
    _chatroomMap.clear();
    _filteredChatroomMap.clear();
    setState(() {
      _chatroomMap.addEntries(chatroomList.map((e) => MapEntry(e.id, e)));
      _filteredChatroomMap.addAll(_chatroomMap);
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
                                .contains(text.toLowerCase()));
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
                  ]),
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
                  await _showContextMenu(context, userState);
                },
                child: HomeContact(
                    chatroom: chatroomList[i],
                    onClick: () {
                      switch (chatroomList[i].type) {
                        case ChatroomType.oneToOne:
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) =>
                                ChatRoomScreen(chatroom: chatroomList[i]),
                            settings: RouteSettings(
                                name: "/chatroom/${chatroomList[i].id}"),
                          ))
                              .then((value) async {
                            await ChatroomStore().save(value);
                            await _loadChatroom();
                          });
                          break;
                        case ChatroomType.group:
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => ChatRoomScreenGroup(
                                chatroom: chatroomList[i] as GroupChat),
                            settings: RouteSettings(
                                name: "/chatroom-group/${chatroomList[i].id}"),
                          ))
                              .then((value) async {
                            if ((value as GroupChat).members.isNotEmpty) {
                              await ChatroomStore().save(value);
                            }
                            await _loadChatroom();
                          });
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
                          builder: (_) => ChatRoomScreen(chatroom: chatroom),
                          settings:
                              RouteSettings(name: "/chatroom/${chatroom.id}"),
                        ))
                        .then((value) => setState(() => {_loadChatroom()}));
                    break;
                  case ChatroomType.group:
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => ChatRoomScreenGroup(
                              chatroom: chatroom as GroupChat),
                          settings: RouteSettings(
                              name: "/chatroom-group/${chatroom.id}"),
                        ))
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
        Navigator.of(context).push(_route(const SettingsScreen())).then(
            (value) => setState(() => {_loadChatroomFuture = _loadChatroom()}));
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

  _showContextMenu(BuildContext context, UserState userState) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          (chatroomListForDeleteToGestureDetector[
                      chatroomListForDeleteToGestureDetectorID]
                  .isMuted)
              ? PopupMenuItem(
                  child: const Text('Unmute chatroom'),
                  onTap: () async {
                    Future.delayed(const Duration(seconds: 0), () async {
                      String chatroomId =
                          chatroomListForDeleteToGestureDetector[
                                  chatroomListForDeleteToGestureDetectorID]
                              .id;
                      if (_filteredChatroomMap[chatroomId]?.type ==
                          ChatroomType.oneToOne) {
                        //one to one chatroom Unmute
                        OneToOneChat chatroom =
                            _filteredChatroomMap[chatroomId] as OneToOneChat;
                        await ChatroomStore().save(OneToOneChat(
                          target: chatroom.target,
                          latestMessage: chatroom.latestMessage,
                          unread: chatroom.unread,
                          createdAt: chatroom.createdAt,
                          isMuted: false,
                        ));
                        await _loadChatroom();
                      } else if (_filteredChatroomMap[chatroomId]?.type ==
                          ChatroomType.group) {
                        //group chatroom Unmute
                        GroupChat chatroom =
                            _filteredChatroomMap[chatroomId] as GroupChat;
                        await ChatroomStore().save(GroupChat(
                          id: chatroom.id,
                          members: chatroom.members,
                          name: chatroom.name,
                          latestMessage: chatroom.latestMessage,
                          unread: chatroom.unread,
                          createdAt: chatroom.createdAt,
                          groupType: chatroom.groupType,
                          description: chatroom.description,
                          profilePicUrl: chatroom.profilePicUrl,
                          updatedAt: chatroom.updatedAt,
                          isMuted: false,
                        ));
                        await _loadChatroom();
                      } else {
                        throw Exception('Chatroom type not found');
                      }
                    });
                  },
                  value: "Unmute chatroom",
                )
              : PopupMenuItem(
                  child: const Text('Mute chatroom'),
                  onTap: () async {
                    Future.delayed(const Duration(seconds: 0), () async {
                      String chatroomId =
                          chatroomListForDeleteToGestureDetector[
                                  chatroomListForDeleteToGestureDetectorID]
                              .id;
                      if (_filteredChatroomMap[chatroomId]?.type ==
                          ChatroomType.oneToOne) {
                        //one to one chatroom mute
                        OneToOneChat chatroom =
                            _filteredChatroomMap[chatroomId] as OneToOneChat;
                        await ChatroomStore().save(OneToOneChat(
                          target: chatroom.target,
                          latestMessage: chatroom.latestMessage,
                          unread: chatroom.unread,
                          createdAt: chatroom.createdAt,
                          isMuted: true,
                        ));
                        await _loadChatroom();
                      } else if (_filteredChatroomMap[chatroomId]?.type ==
                          ChatroomType.group) {
                        //group chatroom mute
                        GroupChat chatroom =
                            _filteredChatroomMap[chatroomId] as GroupChat;
                        await ChatroomStore().save(GroupChat(
                          id: chatroom.id,
                          members: chatroom.members,
                          name: chatroom.name,
                          latestMessage: chatroom.latestMessage,
                          unread: chatroom.unread,
                          createdAt: chatroom.createdAt,
                          groupType: chatroom.groupType,
                          description: chatroom.description,
                          profilePicUrl: chatroom.profilePicUrl,
                          updatedAt: chatroom.updatedAt,
                          isMuted: true,
                        ));
                        await _loadChatroom();
                      } else {
                        throw Exception('Chatroom type not found');
                      }
                    });
                  },
                  value: "Mute chatroom",
                ),
          PopupMenuItem(
            child: const Text('Delete chatroom'),
            onTap: () async {
              Future.delayed(const Duration(seconds: 0), () async {
                String chatroomId = chatroomListForDeleteToGestureDetector[
                        chatroomListForDeleteToGestureDetectorID]
                    .id;
                if (_filteredChatroomMap[chatroomId]?.type ==
                    ChatroomType.oneToOne) {
                  //one to one chatroom deletion
                  bool status = await ChatroomStore().remove(chatroomId);
                  if (status) {
                    await MessageStore()
                        .removeAllMessageByChatroomId(chatroomId);
                    setState(() {
                      _chatroomMap.remove(chatroomId);
                      _filteredChatroomMap.remove(chatroomId);
                    });
                    await _loadChatroom();
                  } else {
                    throw Exception(
                        'Chatroom already has been deleted or chatroom not found');
                  }
                } else if (_filteredChatroomMap[chatroomId]?.type ==
                    ChatroomType.group) {
                  //check whether the group is left, or blocked, if not, the user should not delete the group
                  if ((_filteredChatroomMap[chatroomId] as GroupChat)
                              .members
                              .firstWhereOrNull((element) =>
                                  element.user.userId ==
                                  userState.me!.userId) ==
                          null ||
                      await BlockStore()
                          .contain(_filteredChatroomMap[chatroomId]!.id)) {
                    //if the group is left or blocked, allow to delete the group
                    bool status = await ChatroomStore().remove(chatroomId);
                    if (status) {
                      setState(() {
                        _chatroomMap.remove(chatroomId);
                        _filteredChatroomMap.remove(chatroomId);
                      });
                      await _loadChatroom();
                    } else {
                      throw Exception(
                          'Chatroom already has been deleted or chatroom not found');
                    }
                  } else {
                    //showdialog to alert user the group is not left or not blocked
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: const Text("Action failed"),
                              content: const Text(
                                  "Group chatrooms can only be deleted if you left or blocked the group."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ]);
                        });
                  }
                } else {
                  throw Exception('Chatroom type not found');
                }
              });
            },
            value: "Delete chatroom",
          ),
        ]);
  }
}
