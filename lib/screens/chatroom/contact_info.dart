import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/access_change_event.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/received_plain_message.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/block_api.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom_screen_group.dart';
import 'package:fyp_chat_app/screens/home/create_group_screen.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/block_store.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:collection/collection.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({
    Key? key,
    required this.chatroom,
    required this.blockedFuture,
  }) : super(key: key);

  final Chatroom chatroom;
  final Future<bool> blockedFuture;

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  // Change the data type of the lists below if necessary
  List<int> _media = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  Offset _tapPosition = Offset.zero;

  late StreamSubscription<ReceivedChatEvent> _messageSubscription;

  Future<bool> checkSelfAccount(
      GroupMember chatroom, int index, UserState myAcc) async {
    if (myAcc.me == null) {
      return true;
    }
    if (chatroom.user.userId == myAcc.me!.userId) {
      return true;
    }
    return false;
  }

  Future<List<Chatroom>> checkCommonGroupChat(
      Chatroom chatroom, UserState userState) async {
    if (chatroom.type == ChatroomType.group) {
      return [];
    }
    List<Chatroom> grouplist = await ChatroomStore().getAllChatroom();
    return grouplist
        .where((element) => element.type == ChatroomType.group)
        .where((element) => checkIfInGroup(
            (chatroom as OneToOneChat).target.userId,
            (element as GroupChat).members,
            userState))
        .toList();
  }

  bool checkIfInGroup(
      String id, List<GroupMember> memberList, UserState userState) {
    bool meInGroup = false;
    bool targetInGroup = false;
    for (var element in memberList) {
      meInGroup = meInGroup || element.user.userId == userState.me?.userId;
      targetInGroup = targetInGroup || element.user.userId == id;
    }
    if (meInGroup && targetInGroup) {
      return true;
    }
    return false;
  }

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  bool checkIsAdmin(UserState userState) {
    if (widget.chatroom.type != ChatroomType.group) {
      return false;
    }
    if ((widget.chatroom as GroupChat).members.firstWhereOrNull(
            (member) => member.user.userId == userState.me?.userId) ==
        null) {
      return false;
    }
    return (widget.chatroom as GroupChat)
            .members
            .firstWhereOrNull(
                (member) => member.user.userId == userState.me?.userId)!
            .role ==
        Role.admin;
  }

  GroupMember determineListViewIndexForCommonGroupList(
      UserState userState, List<GroupMember> groupMembers, int index) {
    return checkIsAdmin(userState)
        ? groupMembers[index - 1]
        : groupMembers[index];
  }

  @override
  void initState() {
    super.initState();
    _messageSubscription = Provider.of<UserState>(context, listen: false)
        .messageStream
        .listen((receivedChatEvent) async {
      if (receivedChatEvent.chatroom.id != widget.chatroom.id) {
        // skip other chatroom event
        return;
      }
      switch (receivedChatEvent.event.type) {
        case FCMEventType.textMessage:
          break;
        case FCMEventType.mediaMessage:
          break;
        case FCMEventType.patchGroup:
          // TODO: Handle this case.
          break;
        case FCMEventType.addMember:
          final event = receivedChatEvent.event as AccessControlEvent;
          final member = await GroupMemberStore()
              .getbyChatroomIdAndUserId(widget.chatroom.id, event.targetUserId);
          setState(() {
            if (!(widget.chatroom as GroupChat).members.contains(member)) {
              (widget.chatroom as GroupChat).members.add(member!);
            } 
          });
          break;
        case FCMEventType.kickMember:
          final event = receivedChatEvent.event as AccessControlEvent;
          setState(() {
            (widget.chatroom as GroupChat)
                .members
                .removeWhere((member) => member.user.id == event.targetUserId);
          });
          break;
        case FCMEventType.promoteAdmin:
        case FCMEventType.demoteAdmin:
          final event = receivedChatEvent.event as AccessControlEvent;
          final member = await GroupMemberStore()
              .getbyChatroomIdAndUserId(widget.chatroom.id, event.targetUserId);
          setState(() {
            (widget.chatroom as GroupChat)
                .members
                .removeWhere((member) => member.user.id == event.targetUserId);
            (widget.chatroom as GroupChat).members.add(member!);
          });
          break;
        case FCMEventType.memberJoin:
          final member = await GroupMemberStore().getbyChatroomIdAndUserId(
              widget.chatroom.id, receivedChatEvent.event.senderUserId);
          setState(() {
            if (!(widget.chatroom as GroupChat).members.contains(member)) {
              (widget.chatroom as GroupChat).members.add(member!);
            }
          });
          break;
        case FCMEventType.memberLeave:
          setState(() {
            (widget.chatroom as GroupChat).members.removeWhere((member) =>
                member.user.id == receivedChatEvent.event.senderUserId);
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          leadingWidth: 24,
          leading: IconButton(
            onPressed: () => Navigator.pop(context, widget.chatroom),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Row(
            children: <Widget>[
              CircleAvatar(
                // child: profilePicture ? null : Icon(Icons.person, size: 20),
                child: (widget.chatroom.type == ChatroomType.group)
                    ? const Icon(Icons.group, size: 20, color: Colors.white)
                    : const Icon(Icons.person, size: 20, color: Colors.white),
                radius: 20,
                backgroundColor: Colors.blueGrey,
              ),
              const SizedBox(width: 12),
              Text(widget.chatroom.name),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 72,
                  // child: profilePicture ? null : Icon(Icons.person, size: 48),
                  // backgroundImage: profileImage,
                  child: (widget.chatroom.type == ChatroomType.group)
                      ? const Icon(Icons.group, size: 72, color: Colors.white)
                      : const Icon(Icons.person, size: 72, color: Colors.white),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 14),
              Text(widget.chatroom.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                  )),
              Text(
                // isGroup ? "Group - $participants participants" : "Known as $user.username"
                widget.chatroom.type == ChatroomType.group
                    ? ((widget.chatroom as GroupChat).members.length)
                            .toString() +
                        ((widget.chatroom as GroupChat).members.length > 1
                            ? " participants"
                            : " participant")
                    : widget.chatroom.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
              // Option buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Notification button
                  Column(children: [
                    InkWell(
                      onTap: () {
                        print("Mute notifications from testuser");
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Mute",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  const SizedBox(width: 32),
                  // Search button
                  Column(children: [
                    InkWell(
                      onTap: () {
                        print("Search");
                      },
                      child: Ink(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ]),
                  (widget.chatroom.type == ChatroomType.group &&
                          checkIsAdmin(userState))
                      ? const SizedBox(width: 32)
                      : const SizedBox(width: 0),
                  (widget.chatroom.type == ChatroomType.group &&
                          checkIsAdmin(userState))
                      ? Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateGroupScreen(
                                  isCreateGroup: false,
                                  fromContactInfo: false,
                                  group: widget.chatroom as GroupChat,
                                ),
                              ));
                            },
                            child: Ink(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white70,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ])
                      : const SizedBox(width: 0),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Status / Group description
              GestureDetector(
                child: ListTile(
                  title: Text(
                    (widget.chatroom.type == ChatroomType.group)
                        ? "Group description"
                        : "Status",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    (widget.chatroom.type == ChatroomType.group)
                        ? "This is a new USTalk group!"
                        : "Hi! I'm using USTalk.",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              //Official group
              (widget.chatroom.type == ChatroomType.group &&
                      (widget.chatroom as GroupChat).groupType ==
                          GroupType.Course)
                  ? GestureDetector(
                      child: const ListTile(
                        leading: SizedBox(
                          height: double.infinity,
                          child: Icon(Icons.fact_check, color: Colors.black),
                        ),
                        title: Text(
                          "Official Course Group",
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "This is a authorized course group chat from HKUST",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              (widget.chatroom.type == ChatroomType.group &&
                      (widget.chatroom as GroupChat).groupType ==
                          GroupType.Course)
                  ? const Divider(thickness: 2, indent: 8, endIndent: 8)
                  : Container(),
              /*
              // Disappearing Messages
              InkWell(
                onTap: () {/* isGroup ? EditGroupDescription : null */},
                child: ListTile(
                  leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.speed_rounded, color: Colors.black),
                  ),
                  title: const Text(
                    "Disappearing Messages",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Off", // disappearing ? "On" : "Off"
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              */
              // Check security number * DON'T SHOW THIS IN GROUP INFO *
              InkWell(
                  onTap: () {/* isGroup ? EditGroupDescription : null */},
                  child: ListTile(
                      leading: const SizedBox(
                        height: double.infinity,
                        child: Icon(Icons.verified_user_outlined,
                            color: Colors.black),
                      ),
                      title: const Text(
                        "View public key",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: (widget.chatroom.type == ChatroomType.group)
                          ? Text(
                              "All messages are end-to-end encrypted.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            )
                          : Text(
                              "All messages are end-to-end encrypted.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ))),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Shared Media
              Row(
                children: [
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Shared Media",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 92,
                        width: MediaQuery.of(context).size.width - 32,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _media.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  if (index > 0) ...[const SizedBox(width: 8)],
                                  Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: const BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: InkWell(
                          onTap: () {/* View all media */},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "View All", // isGroup ? "Group description" : "Status",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Group members
              (widget.chatroom.type == ChatroomType.group)
                  ? Row(
                      children: const [
                        SizedBox(width: 16),
                        Text(
                          "Participants:", // isGroup ? "$participants members" : "$groups groups in common",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: const [
                        SizedBox(width: 16),
                        Text(
                          "Groups in common", // isGroup ? "$participants members" : "$groups groups in common",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 8),
              if (widget.chatroom.type == ChatroomType.group)
                //Group List View
                Builder(builder: (_) {
                  final chatroom = widget.chatroom as GroupChat;
                  return ListView.builder(
                      // +1 for add members
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: checkIsAdmin(userState)
                          ? chatroom.members.length + 1
                          : chatroom.members.length,
                      itemBuilder: (_, index) {
                        // Add member
                        if (index == 0 && checkIsAdmin(userState)) {
                          return InkWell(
                            onTap: () {
                              // for (var i in (snapshot.data
                              //     as List<GroupMember>)) {
                              //   print(i.user.name);
                              // }
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateGroupScreen(
                                  isCreateGroup: false,
                                  fromContactInfo: false,
                                  group: widget.chatroom as GroupChat,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: const [
                                  SizedBox(width: 16),
                                  CircleAvatar(
                                    radius: 24,
                                    child: Icon(Icons.add,
                                        size: 24, color: Colors.white),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  SizedBox(width: 16),
                                  Text("Add members...",
                                      style: TextStyle(fontSize: 16))
                                ],
                              ),
                            ),
                          );
                        }
                        // Group members
                        return InkWell(
                          onTapDown: (position) {
                            print(chatroom.members.length);
                            return _getTapPosition(position);
                          },
                          onLongPress: () async {
                            if (checkIsAdmin(userState) &&
                                !(await checkSelfAccount(
                                    determineListViewIndexForCommonGroupList(
                                        userState, chatroom.members, index),
                                    index,
                                    userState))) {
                              await _showContextMenu(context,
                                  chatroom.members[index - 1], userState);
                            }
                          },
                          onTap: () async {
                            /* direct to OneToOne chat */
                            if (!(await checkSelfAccount(
                                determineListViewIndexForCommonGroupList(
                                    userState, chatroom.members, index),
                                index,
                                userState))) {
                              Chatroom? pmChatroom = await ChatroomStore().get(
                                  determineListViewIndexForCommonGroupList(
                                          userState, chatroom.members, index)
                                      .user
                                      .userId);
                              if (pmChatroom == null) {
                                // havent have chatroom in the chatroom store but have contact in contact store
                                // store chatroom in chatroom store
                                pmChatroom = OneToOneChat(
                                  target:
                                      determineListViewIndexForCommonGroupList(
                                              userState,
                                              chatroom.members,
                                              index)
                                          .user,
                                  unread: 0,
                                  createdAt: DateTime.now(),
                                );
                                await ChatroomStore().save(pmChatroom);
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ChatRoomScreen(chatroom: pmChatroom!),
                                settings: RouteSettings(
                                    name: "/chatroom/${pmChatroom.id}"),
                              ));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                const CircleAvatar(
                                  radius: 24,
                                  child: Icon(Icons.person,
                                      size: 28, color: Colors.white),
                                  backgroundColor: Colors.blueGrey,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                    // isGroup ? _members[index].name : _common_group[index].name,
                                    ((checkIsAdmin(userState)
                                                    ? chatroom
                                                        .members[index - 1]
                                                    : chatroom.members[index])
                                                .user
                                                .userId ==
                                            userState.me!.userId)
                                        ? "You"
                                        : ((checkIsAdmin(userState)
                                                        ? chatroom
                                                            .members[index - 1]
                                                        : chatroom
                                                            .members[index])
                                                    .user
                                                    .displayName ==
                                                null)
                                            ? determineListViewIndexForCommonGroupList(
                                                    userState,
                                                    chatroom.members,
                                                    index)
                                                .user
                                                .username
                                            : determineListViewIndexForCommonGroupList(
                                                    userState,
                                                    chatroom.members,
                                                    index)
                                                .user
                                                .displayName!,
                                    style: const TextStyle(fontSize: 16)),
                                const Expanded(child: SizedBox()),
                                ((checkIsAdmin(userState)
                                                ? chatroom.members[index - 1]
                                                : chatroom.members[index])
                                            .role ==
                                        Role.admin)
                                    ? const Icon(Icons.manage_accounts,
                                        size: 36, color: Colors.blueGrey)
                                    : Container(),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        );
                      });
                }),
              if (widget.chatroom.type == ChatroomType.oneToOne)
                // oneToOne Chatroom List View
                FutureBuilder<List<Chatroom>>(
                    future: checkCommonGroupChat(widget.chatroom, userState),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final chatrooms = snapshot.data!;
                      return ListView.builder(
                          // +1 for add members / create group with the user
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: chatrooms.length,
                          itemBuilder: (context, index) {
                            // Common groups
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatRoomScreenGroup(
                                    chatroom: chatrooms[index] as GroupChat,
                                  ),
                                  settings: RouteSettings(
                                    name:
                                        "/chatroom-group/${chatrooms[index].id}",
                                  ),
                                ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    const CircleAvatar(
                                      radius: 24,
                                      child: Icon(Icons.group),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                        // isGroup ? _members[index].name : _common_group[index].name,
                                        chatrooms[index].name,
                                        style: const TextStyle(fontSize: 16))
                                  ],
                                ),
                              ),
                            );
                          });
                    }),

              const Divider(thickness: 2, indent: 8, endIndent: 8),
              // Block / Leave group
              if ((widget.chatroom.type == ChatroomType.group)) ...[
                InkWell(
                  onTap: () {
                    /* confirm => process leave group */
                    _leaveGroupAlert(context);
                  },
                  child: const ListTile(
                    leading:
                        Icon(Icons.exit_to_app, size: 24, color: Colors.red),
                    title: Text(
                      "Leave Group",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ),
              ],
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FutureBuilder<bool>(
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == false) {
                            return AlertDialog(
                              //Blocking button
                              title:
                                  (widget.chatroom.type == ChatroomType.group)
                                      ? const Text("Block group?")
                                      : const Text("Block user?"),
                              content: (widget.chatroom.type ==
                                      ChatroomType.group)
                                  ? const Text(
                                      "You will no longer be able to receive messages from this group.")
                                  : const Text(
                                      "You will no longer be able to receive messages from this user."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool status = await BlockApi()
                                        .sendBlockRequest(widget.chatroom.id);
                                    if (status) {
                                      //update blocked chatroom in blockstore
                                      await BlockStore()
                                          .storeBlocked(widget.chatroom.id);
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context, widget.chatroom);
                                  },
                                  child: const Text("Block"),
                                ),
                              ],
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data == true) {
                            return AlertDialog(
                              //Unblock button
                              title:
                                  (widget.chatroom.type == ChatroomType.group)
                                      ? const Text("Unblock group?")
                                      : const Text("Unblock user?"),
                              content: (widget.chatroom.type ==
                                      ChatroomType.group)
                                  ? const Text(
                                      "You will be able to receive messages from this group.")
                                  : const Text(
                                      "You will be able to receive messages from this user."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool status = await BlockApi()
                                        .sendUnblockRequest(widget.chatroom.id);
                                    if (status) {
                                      //update chatroom in chatroomstore
                                      await BlockStore()
                                          .removeBlocked(widget.chatroom.id);
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context, widget.chatroom);
                                  },
                                  child: const Text("Unblock"),
                                ),
                              ],
                            );
                          } else {
                            return AlertDialog(
                              //Blocking button
                              title:
                                  (widget.chatroom.type == ChatroomType.group)
                                      ? const Text("Block group?")
                                      : const Text("Block user?"),
                              content: (widget.chatroom.type ==
                                      ChatroomType.group)
                                  ? const Text(
                                      "You will no longer be able to receive messages from this group.")
                                  : const Text(
                                      "You will no longer be able to receive messages from this user."),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, widget.chatroom),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    //nothing use becoz the blocking status is still loading
                                  },
                                  child: const Text("Block"),
                                ),
                              ],
                            );
                          }
                        },
                        future: widget.blockedFuture),
                  );
                },
                child: FutureBuilder<bool>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          leading: const Icon(Icons.block,
                              size: 24, color: Colors.red),
                          title: (snapshot.hasData && snapshot.data == false)
                              ? Text(
                                  "Block${(widget.chatroom.type == ChatroomType.group) ? ' Group' : ''}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 18),
                                )
                              : Text(
                                  "Unblock${(widget.chatroom.type == ChatroomType.group) ? ' Group' : ''}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ),
                        );
                      } else {
                        //just template becoz the blocking status is still loading
                        return ListTile(
                            leading: const Icon(Icons.block,
                                size: 24, color: Colors.red),
                            title: Text(
                              "Block${(widget.chatroom.type == ChatroomType.group) ? ' Group' : ''}",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 18),
                            ));
                      }
                    },
                    future: widget.blockedFuture),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _showContextMenu(BuildContext context, GroupMember memberSelectedForTheAction,
      UserState userState) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          //admin visible menu
          //TODO : Wait backend finish and DEBUG
          PopupMenuItem(
            child: const Text('Promote admin'),
            onTap: () async {
              await GroupChatApi().addAdmin(
                  widget.chatroom.id, memberSelectedForTheAction.user.userId);
              //get newest info of member from server
              GroupMember memberfromAPI = await GroupChatApi().getGroupMember(
                  widget.chatroom.id, memberSelectedForTheAction.user.userId);
              await GroupMemberStore().save(
                  widget.chatroom.id,
                  GroupMember(
                      id: memberSelectedForTheAction.id,
                      user: memberfromAPI.user,
                      role: Role.admin));
              setState(() {
                (widget.chatroom as GroupChat).members.removeWhere((element) =>
                    (element.user.userId ==
                        memberSelectedForTheAction.user.userId));
                print(memberfromAPI.role);
                (widget.chatroom as GroupChat).members.add(GroupMember(
                    id: memberSelectedForTheAction.id,
                    user: memberfromAPI.user,
                    role: Role.admin));
              });
              final memberName =
                  (memberSelectedForTheAction.user.displayName == null)
                      ? memberSelectedForTheAction.user.username
                      : memberSelectedForTheAction.user.displayName!;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Promoted $memberName as Admin'),
              ));
            },
            value: "Add admin",
          ),
          PopupMenuItem(
            child: const Text('Demote admin'),
            onTap: () async {
              await GroupChatApi().removeAdmin(
                  widget.chatroom.id, memberSelectedForTheAction.user.userId);
              GroupMember memberfromAPI = await GroupChatApi().getGroupMember(
                  widget.chatroom.id, memberSelectedForTheAction.user.userId);
              await GroupMemberStore().save(
                  widget.chatroom.id,
                  GroupMember(
                      id: memberSelectedForTheAction.id,
                      user: memberfromAPI.user,
                      role: Role.member));
              setState(() {
                (widget.chatroom as GroupChat).members.removeWhere((element) =>
                    (element.user.userId ==
                        memberSelectedForTheAction.user.userId));
                print(memberfromAPI.role);
                (widget.chatroom as GroupChat).members.add(GroupMember(
                    id: memberSelectedForTheAction.id,
                    user: memberfromAPI.user,
                    role: Role.member));
              });
              final memberName =
                  (memberSelectedForTheAction.user.displayName == null)
                      ? memberSelectedForTheAction.user.username
                      : memberSelectedForTheAction.user.displayName!;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Demoted $memberName as Member'),
              ));
            },
            value: "Remove admin",
          ),
          PopupMenuItem(
            child: const Text('Remove member'),
            onTap: () async {
              await GroupChatApi().kickMember(
                  widget.chatroom.id, memberSelectedForTheAction.user.userId);
            },
            value: "Remove member",
          ),
        ]);
  }

  _leaveGroupAlert(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Leave Group"),
      onPressed: () async {
        /* TODO: Leave Group Action */
        Navigator.pop(context, 'Leave Group');
        bool leaveGroupSuccess =
            await GroupChatApi().leaveGroup(widget.chatroom.id);
        //return to home screen (delete if unnecessary)
        if (leaveGroupSuccess) {
          ChatroomStore().remove(widget.chatroom.id);
          (widget.chatroom as GroupChat).members.clear();
          Navigator.pop(context, widget.chatroom);
        } else {
          _leaveGroupFailedAlert(context);
        }
      },
    );
    AlertDialog leaveGroupDialog = AlertDialog(
      title: const Text("Leaving group"),
      content: const Text("Would you like to leave this chat group?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return leaveGroupDialog;
      },
    );
  }

  _leaveGroupFailedAlert(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    AlertDialog leaveGroupDialog = AlertDialog(
      title: const Text("Leave group failed"),
      content: const Text(
          "Please try again.\nIf this window keeps prompt out, please contact the developers"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return leaveGroupDialog;
      },
    );
  }
}
