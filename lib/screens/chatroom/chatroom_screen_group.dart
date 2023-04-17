import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/music_player.dart';
import 'package:fyp_chat_app/components/video_player.dart';
import 'package:fyp_chat_app/models/access_change_event.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/media_message.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/chatroom/contact_info.dart';
import 'package:fyp_chat_app/signal/signal_client.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:fyp_chat_app/storage/media_store.dart';
import 'package:fyp_chat_app/storage/message_store.dart';
import 'package:fyp_chat_app/storage/block_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:url_launcher/url_launcher.dart';
import '../../components/attachment_menu.dart';
import '../camera/camera_screen.dart';

class ChatRoomScreenGroup extends StatefulWidget {
  const ChatRoomScreenGroup({
    Key? key,
    required this.chatroom,
  }) : super(key: key);

  final GroupChat chatroom;

  @override
  State<ChatRoomScreenGroup> createState() => _ChatRoomScreenGroupState();
}

class _ChatRoomScreenGroupState extends State<ChatRoomScreenGroup> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _textMessage = false;
  bool _emojiBoardShown = false;
  bool _attachmentMenuShown = false;
  late final Future<bool> _messageHistoryFuture;
  final List<ChatMessage> _messages = [];
  final Map<String, String> _names = {};
  final Map<String, String> _mediaMap = {};
  int _page = 0; // pagination
  bool _isLastPage = false;
  static const _pageSize = 100;
  late StreamSubscription<ReceivedChatEvent> _messageSubscription;
  late final UserState _state;
  late Future<bool> blockedFuture;
  @override
  void initState() {
    super.initState();
    _messageHistoryFuture = _loadMessageHistory();
    // check chatroom is blocked or not
    blockedFuture = BlockStore().contain(widget.chatroom.id);
    // set chatting with
    _state = Provider.of<UserState>(context, listen: false);
    _state.chatroom = widget.chatroom;
    // register new message listener
    _messageSubscription = Provider.of<UserState>(context, listen: false)
        .messageStream
        .listen((receivedChatEvent) async {
      if (receivedChatEvent.chatroom.id != widget.chatroom.id) {
        // skip other chatroom event
        return;
      }
      switch (receivedChatEvent.event.type) {
        case FCMEventType.textMessage:
          setState(() {
            _messages.insert(0, receivedChatEvent.event as PlainMessage);
          });
          break;
        case FCMEventType.mediaMessage:
          final localStorage = await getTemporaryDirectory();
          final media = await MediaStore()
              .getMediaById((receivedChatEvent.event as MediaMessage).media.id);
          final filePath =
              "${localStorage.path}/${media.id}${media.fileExtension}";
          final file = File(filePath);
          await file.writeAsBytes(media.content);
          setState(() {
            _mediaMap.addAll({media.id: filePath});
          });
          _messages.insert(0, receivedChatEvent.event as MediaMessage);
          break;
        case FCMEventType.patchGroup:
          // TODO: Handle this case.
          break;
        case FCMEventType.addMember:
          final event = receivedChatEvent.event as AccessControlEvent;
          final member = await GroupMemberStore()
              .getbyChatroomIdAndUserId(widget.chatroom.id, event.targetUserId);
          setState(() {
            if (!widget.chatroom.members.contains(member)) {
              widget.chatroom.members.add(member!);
            }
          });
          break;
        case FCMEventType.kickMember:
          final event = receivedChatEvent.event as AccessControlEvent;
          setState(() {
            widget.chatroom.members
                .removeWhere((member) => member.user.id == event.targetUserId);
          });
          break;
        case FCMEventType.promoteAdmin:
        case FCMEventType.demoteAdmin:
          final event = receivedChatEvent.event as AccessControlEvent;
          final member = await GroupMemberStore()
              .getbyChatroomIdAndUserId(widget.chatroom.id, event.targetUserId);
          setState(() {
            widget.chatroom.members
                .removeWhere((member) => member.user.id == event.targetUserId);
            widget.chatroom.members.add(member!);
          });
          break;
        case FCMEventType.memberJoin:
          final member = await GroupMemberStore().getbyChatroomIdAndUserId(
              widget.chatroom.id, receivedChatEvent.event.senderUserId);
          setState(() {
            if (!widget.chatroom.members.contains(member)) {
              widget.chatroom.members.add(member!);
            }
          });
          break;
        case FCMEventType.memberLeave:
          setState(() {
            widget.chatroom.members.removeWhere((member) =>
                member.user.id == receivedChatEvent.event.senderUserId);
          });
          break;
      }
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
    // Extract media from database, and put to temporary storage
    late final media;
    final localStorage = await getTemporaryDirectory();
    messages.forEach((msg) async {
      // Message > 2 => Not text, not system log, not media key
      if (msg.messageType.index > 2 && !_mediaMap.containsKey(msg.id)) {
        final media =
            await MediaStore().getMediaById((msg as MediaMessage).media.id);
        final filePath =
            "${localStorage.path}/${media.id}${media.fileExtension}";
        final file = File(filePath);
        await file.writeAsBytes(media.content);
        setState(() {
          _mediaMap[media.id] = filePath;
        });
      }
    });

    GroupChat room = widget.chatroom;
    final members = room.members;
    final names = <String, String>{
      for (var v in members) v.user.userId: v.user.name
    };

    setState(() {
      _messages.addAll(messages);
      _names.addAll(names);
    });
    return true;
  }

  String get message => _messageController.text;

  void _sendMessage(String message) async {
    _messageController.clear();
    final sentMessage = await SignalClient().sendMessageToChatroom(
      _state.me!,
      widget.chatroom,
      message,
    );
    setState(() {
      _messages.insert(0, sentMessage);
      _textMessage = false;
    });
  }

  void _updateMediaMessage(MediaMessage mediaMessage) async {
    final localStorage = await getTemporaryDirectory();
    final media = await MediaStore().getMediaById(mediaMessage.media.id);
    final filePath = "${localStorage.path}/${media.id}${media.fileExtension}";
    final file = File(filePath);
    await file.writeAsBytes(media.content);
    setState(() {
      _mediaMap[media.id] = filePath;
    });
    setState(() {
      _messages.insert(0, mediaMessage);
    });
  }

  // Selecting camera
  void _onCameraSelected() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CameraScreen(
              source: Source.chatroom,
              chatroom: widget.chatroom,
              sendCallback: _updateMediaMessage,
            )));
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
              Navigator.pop(
                  context,
                  GroupChat(
                    id: widget.chatroom.id,
                    members: (widget.chatroom).members,
                    name: widget.chatroom.name,
                    unread: 0,
                    latestMessage: (_messages.isEmpty) ? null : _messages[0],
                    createdAt: widget.chatroom.createdAt,
                    groupType: (widget.chatroom).groupType,
                  ));
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
                    child: Icon(Icons.group, size: 20, color: Colors.white),
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
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ContactInfo(
                          chatroom: widget.chatroom,
                          blockedFuture: blockedFuture)))
                  .then((value) {
                        print((value as GroupChat).members.length);
                        setState(() {
                          blockedFuture =
                              BlockStore().contain(widget.chatroom.id);
                        });
                      }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //showing top bars chatroom name and participant's name
                  Text(widget.chatroom.name),
                  Text(
                    (widget.chatroom).members.isEmpty
                        //if empty, show no ppl in group
                        ? ""
                        : (((widget.chatroom).members[0].user.displayName ==
                                    null)
                                //check first member have display name or not
                                ? (widget.chatroom)
                                    .members[0]
                                    .user
                                    .username
                                    .toString()
                                : (widget.chatroom)
                                    .members[0]
                                    .user
                                    .displayName!
                                    .toString()) +
                            (((widget.chatroom).members.length < 2)
                                //check there is second member or not
                                ? ""
                                : ', ' +
                                    (((widget.chatroom)
                                                .members[1]
                                                .user
                                                .displayName ==
                                            null)
                                        //check second member have display name or not
                                        ? (widget.chatroom)
                                            .members[1]
                                            .user
                                            .username
                                            .toString()
                                        : (widget.chatroom)
                                            .members[1]
                                            .user
                                            .displayName!
                                            .toString()) +
                                    (((widget.chatroom).members.length < 3)
                                        //check if there are more members
                                        ? ""
                                        : ", ...")),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: _messageHistoryFuture,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Chat(
              messages: _messages.map((e) {
                switch (e.messageType) {
                  case MessageType.text:
                    return types.TextMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      text: (e as PlainMessage).content,
                      createdAt: e.sentAt.millisecondsSinceEpoch,
                    );
                  case MessageType.image:
                    if (_mediaMap[(e as MediaMessage).media.id] == null) {
                      return types.TextMessage(
                        id: e.id.toString(),
                        author: types.User(id: e.senderUserId),
                        text: "Loading Image...",
                        createdAt: e.sentAt.millisecondsSinceEpoch,
                      );
                    }
                    return types.ImageMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      name: (e).media.baseName,
                      size: (e).media.content.lengthInBytes,
                      uri: _mediaMap[e.media.id]!,
                    );
                  case MessageType.video:
                    if (_mediaMap[(e as MediaMessage).media.id] == null) {
                      return types.TextMessage(
                        id: e.id.toString(),
                        author: types.User(id: e.senderUserId),
                        text: "Loading Video...",
                        createdAt: e.sentAt.millisecondsSinceEpoch,
                      );
                    }
                    return types.VideoMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      name: (e).media.baseName,
                      size: (e).media.content.lengthInBytes,
                      uri: _mediaMap[e.media.id]!,
                    );
                  case MessageType.audio:
                    if (_mediaMap[(e as MediaMessage).media.id] == null) {
                      return types.TextMessage(
                        id: e.id.toString(),
                        author: types.User(id: e.senderUserId),
                        text: "Loading Audio...",
                        createdAt: e.sentAt.millisecondsSinceEpoch,
                      );
                    }
                    return types.AudioMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      name: (e).media.baseName,
                      size: (e).media.content.lengthInBytes,
                      duration: const Duration(seconds: 2),
                      uri: _mediaMap[e.media.id]!,
                    );
                  case MessageType.document:
                    if (_mediaMap[(e as MediaMessage).media.id] == null) {
                      return types.TextMessage(
                        id: e.id.toString(),
                        author: types.User(id: e.senderUserId),
                        text: "Loading Document...",
                        createdAt: e.sentAt.millisecondsSinceEpoch,
                      );
                    }
                    return types.FileMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      name: (e).media.baseName,
                      size: (e).media.content.lengthInBytes,
                      uri: _mediaMap[e.media.id]!,
                    );

                  default:
                    return types.TextMessage(
                      id: e.id.toString(),
                      author: types.User(id: e.senderUserId),
                      text: "Undefined Message",
                      createdAt: e.sentAt.millisecondsSinceEpoch,
                    );
                }
              }).toList(),
              showUserNames: true,
              nameBuilder: (userId) => UserName(
                  author: types.User(
                      id: userId, firstName: _names[userId] ?? "Unknown User")),
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
              videoMessageBuilder: (p0, {required messageWidth}) => Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: VideoPlayer(
                  video: File(p0.uri),
                ),
              ),
              audioMessageBuilder: (p0, {required messageWidth}) => Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    maxHeight: 100,
                  ),
                  child: MusicPlayer(
                    audio: p0.uri,
                    isSender: userState.me!.userId == p0.author.id,
                  )),
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
                          if ((snapshot.hasData && snapshot.data == true) ||
                              (widget.chatroom).members.firstWhereOrNull(
                                      (member) =>
                                          member.user.userId ==
                                          userState.me?.userId) ==
                                  null) {
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
                                        hintText: 'You blocked this group',
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
                                              _attachmentMenuShown = false;
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
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      setState(() {
                                                        _attachmentMenuShown =
                                                            !_attachmentMenuShown;
                                                        _emojiBoardShown =
                                                            false;
                                                      });
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    onPressed: () {
                                                      _onCameraSelected();
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
                          backgroundColor: _textMessage
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey, // <-- Button color
                          foregroundColor: Theme.of(context)
                              .highlightColor, // <-- Splash color
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
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
                  offstage: !_emojiBoardShown && !_attachmentMenuShown,
                  child: SizedBox(
                    height: 250,
                    child: _emojiBoardShown
                        ? EmojiPicker(
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
                          )
                        : AttachmentMenu(
                            chatroom: widget.chatroom,
                            sendCallback: _updateMediaMessage),
                  ),
                ),
              ]),
              onMessageTap: (context, p1) => _handleMessageTap(context, p1),
            );
          },
        ),
      ),
    );
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
