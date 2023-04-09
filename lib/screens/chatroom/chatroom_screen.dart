import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/chatroom/contact_info.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:fyp_chat_app/storage/message_store.dart';
import 'package:fyp_chat_app/storage/block_store.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:url_launcher/url_launcher.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    Key? key,
    required this.chatroom,
  }) : super(key: key);

  final Chatroom chatroom;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _textMessage = false;
  bool _emojiBoardShown = false;
  late final Future<bool> _messageHistoryFuture;
  final List<PlainMessage> _messages = [];
  int _page = 0; // pagination
  bool _isLastPage = false;
  static const _pageSize = 100;
  late StreamSubscription<ReceivedPlainMessage> _messageSubscription;
  late final UserState _state;
  late final Future<bool> blockedFuture;

  @override
  void initState() {
    super.initState();
    _messageHistoryFuture = _loadMessageHistory();
    //check chatroom blocked
    blockedFuture = BlockStore().contain(widget.chatroom.id);
    // set chatting with
    _state = Provider.of<UserState>(context, listen: false);
    _state.chatroom = widget.chatroom;
    // register new message listener
    _messageSubscription = Provider.of<UserState>(context, listen: false)
        .messageStream
        .listen((receivedMessage) {
      setState(() {
        _messages.insert(0, receivedMessage.message);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // remove chatting with
    _state.chatroom = null;
    _messageSubscription.cancel();
  }

  Future<bool> _loadMessageHistory() async {
    final messages = await MessageStore().getMessageByChatroomId(
      widget.chatroom.id,
      start: _page * _pageSize,
      count: _pageSize,
    );
    _page += 1;
    if (messages.length < _pageSize) {
      _isLastPage = true;
    }
    setState(() {
      _messages.addAll(messages);
    });
    return true;
  }

  String get message => _messageController.text;

  void _sendMessage(String message) async {
    _messageController.clear();
    _textMessage = false;
    final sentMessage = await SignalClient().sendMessageToChatroom(
      _state.me!,
      widget.chatroom,
      message,
    );
    setState(() {
      _messages.insert(0, sentMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        extendBody: true,
        appBar: AppBar(
          leadingWidth: 72,
          titleSpacing: 8,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: const [
                Expanded(
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
                // SizedBox(width: 4),
                Expanded(
                  child: CircleAvatar(
                    // child: profilePicture ? null : Icon(Icons.person, size: 48),
                    child: Icon(Icons.person, size: 20, color: Colors.white),
                    radius: 32,
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          //top bar with pop up menu button
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactInfo(
                        chatroom: widget.chatroom,
                        blockedFuture: blockedFuture,
                      ))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chatroom.name),
                  const Text(
                    "",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                _onMenuItemSelected(value as int, userState);
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem("Add to Contact", 0),
                _buildPopupMenuItem("Search", 1),
                _buildPopupMenuItem("Mute Notifications", 2),
                PopupMenuItem(
                  value: 3,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.center,
                      height: 48.0, //default height
                      width: double.infinity,
                      child: Row(
                        children: const <Widget>[
                          Text("More"),
                          Spacer(),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (innerContext) {
                      return [
                        PopupMenuItem(
                          value: 102,
                          child: const Text("Report User"),
                          onTap: () {
                            Navigator.of(innerContext).pop();
                          },
                        ),
                      ];
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        body: FutureBuilder(
          future: _messageHistoryFuture,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Chat(
              messages: _messages
                  .map(
                    (e) => types.TextMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      text: e.content,
                      createdAt: e.sentAt.millisecondsSinceEpoch,
                    ),
                  )
                  .toList(),
              bubbleBuilder: (
                Widget child, {
                required message,
                required nextMessageInGroup,
              }) =>
                  Bubble(
                child: child,
                nip: (userState.me!.userId != message.author.id)
                    ? BubbleNip.leftBottom
                    : BubbleNip.rightBottom,
                color: (userState.me!.userId != message.author.id)
                    ? const Color(0xfff5f5f7)
                    : Theme.of(context).primaryColor,
                showNip: !nextMessageInGroup,
                padding: const BubbleEdges.all(0),
                elevation: 1,
              ),
              onSendPressed: (partialText) {
                _sendMessage(partialText.text);
              },
              user: types.User(
                id: _state.me!.userId,
              ),
              onEndReached: _loadMessageHistory,
              isLastPage: _isLastPage,
              customBottomWidget: Column(children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      FutureBuilder<bool>(
                        future: blockedFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            //blocked, cant input message
                            return Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border:
                                      Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Scrollbar(
                                    controller: _scrollController,
                                    child: TextField(
                                      enabled: false,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      controller: _messageController,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isCollapsed: true,
                                        filled: true,
                                        fillColor: Colors.white70,
                                        hintText: 'Message',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade600),
                                        border: InputBorder.none,
                                        prefixIcon: IconButton(
                                          icon: _emojiBoardShown
                                              ? Icon(
                                                  Icons.keyboard,
                                                  color: Colors.grey.shade600,
                                                )
                                              : Icon(
                                                  Icons.emoji_emotions_outlined,
                                                  color: Colors.grey.shade600,
                                                ),
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() {
                                              _emojiBoardShown =
                                                  !_emojiBoardShown;
                                            });
                                          },
                                        ),
                                        suffixIcon: (_textMessage)
                                            ? null
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.attach_file,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    onPressed: () {
                                                      print("attachment");
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    onPressed: () {
                                                      print("camera");
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (builder) =>
                                                      //             CameraApp()));
                                                    },
                                                  ),
                                                ],
                                              ),
                                      ),
                                      onChanged: (text) {
                                        setState(() {
                                          _textMessage = text.trim().isNotEmpty;
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          _emojiBoardShown = false;
                                        });
                                      },
                                      minLines: 1,
                                      maxLines: 5,
                                    )),
                              ),
                            );
                          } else {
                            //not blocked, normal input
                            return Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Scrollbar(
                                    controller: _scrollController,
                                    child: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      controller: _messageController,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        isCollapsed: true,
                                        filled: true,
                                        fillColor: Colors.white70,
                                        hintText: 'Message',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade600),
                                        border: InputBorder.none,
                                        prefixIcon: IconButton(
                                          icon: _emojiBoardShown
                                              ? Icon(
                                                  Icons.keyboard,
                                                  color: Colors.grey.shade600,
                                                )
                                              : Icon(
                                                  Icons.emoji_emotions_outlined,
                                                  color: Colors.grey.shade600,
                                                ),
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() {
                                              _emojiBoardShown =
                                                  !_emojiBoardShown;
                                            });
                                          },
                                        ),
                                        suffixIcon: (_textMessage)
                                            ? null
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.attach_file,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    onPressed: () {
                                                      print("attachment");
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    onPressed: () {
                                                      print("camera");
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (builder) =>
                                                      //             CameraApp()));
                                                    },
                                                  ),
                                                ],
                                              ),
                                      ),
                                      onChanged: (text) {
                                        setState(() {
                                          _textMessage = text.trim().isNotEmpty;
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          _emojiBoardShown = false;
                                        });
                                      },
                                      minLines: 1,
                                      maxLines: 5,
                                    )),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Theme.of(context)
                              .primaryColor, // <-- Button color
                          foregroundColor: Theme.of(context)
                              .highlightColor, // <-- Splash color
                          minimumSize: const Size(0, 0),
                        ),
                        child: _textMessage
                            ? const Icon(Icons.send, color: Colors.white)
                            : const Icon(Icons.mic, color: Colors.white),
                        onPressed: () {
                          if (message.trim().isNotEmpty) {
                            _sendMessage(message);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !_emojiBoardShown,
                  child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        textEditingController: _messageController,
                        onEmojiSelected: (category, emoji) {
                          setState(() {
                            _textMessage = message.trim().isNotEmpty;
                          });
                        },
                        onBackspacePressed: () {
                          setState(() {
                            _textMessage = message.trim().isNotEmpty;
                          });
                        },
                        config: Config(
                          columns: 8,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Theme.of(context).primaryColor,
                          iconColor: Colors.grey,
                          iconColorSelected: Theme.of(context).primaryColor,
                          backspaceColor: Theme.of(context).primaryColor,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black26,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          loadingIndicator: const SizedBox.shrink(),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                          checkPlatformCompatibility: true,
                        ),
                      )),
                ),
              ]),
              onMessageTap: (context, p1) => _handleMessageTap(context, p1),
            );
          },
        ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, int positon) {
    return PopupMenuItem(
      value: positon,
      child: Text(title),
    );
  }

  _onMenuItemSelected(int value, UserState userState) {
    switch (value) {
      case 0:
        break;

      case 1:
        break;

      case 2:
        break;

      case 3:
        break;
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.TextMessage) {
      var path = message.text;

      if (path.startsWith('http')) {
        try {
          // Update tapped file message to show loading spinner
          final Uri _url = Uri.parse(path);
          if (await canLaunchUrl(_url)) {
            await launchUrl(_url);
          } else {
            throw Exception("cannot open the link");
          }
        } finally {}
      }
    }
  }
}
