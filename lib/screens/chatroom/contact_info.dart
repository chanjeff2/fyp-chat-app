import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/user_icon.dart';
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
import 'package:fyp_chat_app/screens/settings/edit_group_chat.dart';
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
  // List<int> _media = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  Offset _tapPosition = Offset.zero;

  late Chatroom chatroom;

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
    });
  }

  bool checkIsAdmin(UserState userState) {
    if (chatroom.type != ChatroomType.group) {
      return false;
    }
    if ((chatroom as GroupChat).members.firstWhereOrNull(
            (member) => member.user.userId == userState.me?.userId) ==
        null) {
      return false;
    }
    return (chatroom as GroupChat)
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

    setState(() {
      chatroom = widget.chatroom;
    });

    _messageSubscription = Provider.of<UserState>(context, listen: false)
        .messageStream
        .listen((receivedChatEvent) async {
      if (receivedChatEvent.chatroom.id != chatroom.id) {
        // skip other chatroom event
        return;
      }
      switch (receivedChatEvent.event.type) {
        case FCMEventType.textMessage:
          break;
        case FCMEventType.mediaMessage:
          break;
        case FCMEventType.patchGroup:
          setState(() {
            (widget.chatroom as GroupChat)
                .merge(receivedChatEvent.chatroom as GroupChat);
          });
          break;
        case FCMEventType.addMember:
        case FCMEventType.kickMember:
        case FCMEventType.promoteAdmin:
        case FCMEventType.demoteAdmin:
        case FCMEventType.memberJoin:
        case FCMEventType.memberLeave:
          setState(() {
            (chatroom as GroupChat).members.clear();
            (chatroom as GroupChat)
                .members
                .addAll((receivedChatEvent.chatroom as GroupChat).members);
          });
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
        builder: (context, userState, child) => WillPopScope(
              onWillPop: () async {
                Navigator.pop(context, chatroom);
                return true;
              },
              child: Scaffold(
                appBar: AppBar(
                    leadingWidth: 24,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context, chatroom),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    title: Row(
                      children: <Widget>[
                        UserIcon(
                          radius: 20,
                          iconSize: 20,
                          isGroup: chatroom.type == ChatroomType.group,
                          profilePicUrl: chatroom.profilePicUrl,
                        ),
                        const SizedBox(width: 12),
                        Text(chatroom.name),
                      ],
                    ),
                    actions: (chatroom.type == ChatroomType.group &&
                            checkIsAdmin(userState))
                        ? [
                            IconButton(
                                onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditGroupChat(
                                        groupChat: chatroom as GroupChat,
                                      ),
                                    ))
                                        .then((updatedChatroom) {
                                      setState(() {
                                        chatroom = updatedChatroom;
                                      });
                                    }),
                                icon: const Icon(Icons.edit))
                          ]
                        : null),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: UserIcon(
                          radius: 72,
                          iconSize: 72,
                          isGroup: chatroom.type == ChatroomType.group,
                          profilePicUrl: chatroom.profilePicUrl,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(chatroom.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                          )),
                      Text(
                        // isGroup ? "Group - $participants participants" : "Known as $user.username"
                        chatroom.type == ChatroomType.group
                            ? ((chatroom as GroupChat).members.length)
                                    .toString() +
                                ((chatroom as GroupChat).members.length > 1
                                    ? " participants"
                                    : " participant")
                            : "Known as ${(chatroom as OneToOneChat).target.username}",
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
                          Column(
                            children: [
                              if (chatroom.isMuted) ...[
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      chatroom.isMuted = false;
                                    });
                                    await ChatroomStore().save(chatroom);
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_off_outlined,
                                      color: Colors.white70,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Muted",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ] else ...[
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      chatroom.isMuted = true;
                                    });
                                    await ChatroomStore().save(chatroom);
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
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
                              ],
                            ],
                          ),
                          (chatroom.type == ChatroomType.group &&
                                  checkIsAdmin(userState))
                              ? const SizedBox(width: 32)
                              : const SizedBox(width: 0),
                          // Search button (To be implemented)
                          /*
                          Column(children: [
                            InkWell(
                              onTap: () {
                                print("Search");
                              },
                              child: Ink(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
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
                          */
                          (chatroom.type == ChatroomType.group &&
                                  checkIsAdmin(userState))
                              ? const SizedBox(width: 32)
                              : const SizedBox(width: 0),
                          (chatroom.type == ChatroomType.group &&
                                  checkIsAdmin(userState))
                              ? Column(children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => CreateGroupScreen(
                                          isCreateGroup: false,
                                          fromContactInfo: false,
                                          group: chatroom as GroupChat,
                                        ),
                                      ));
                                    },
                                    child: Ink(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
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
                            (chatroom.type == ChatroomType.group)
                                ? "Group description"
                                : "Status",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            (chatroom.type == ChatroomType.group)
                                ? ((chatroom as GroupChat).description ??
                                    "This is a new USTalk group!")
                                : ((chatroom as OneToOneChat).target.status ??
                                    "Hi! I'm using USTalk."),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 2, indent: 8, endIndent: 8),
                      //Official group
                      (chatroom.type == ChatroomType.group &&
                              (chatroom as GroupChat).groupType ==
                                  GroupType.Course)
                          ? GestureDetector(
                              child: const ListTile(
                                leading: SizedBox(
                                  height: double.infinity,
                                  child: Icon(Icons.fact_check,
                                      color: Colors.black),
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
                      (chatroom.type == ChatroomType.group &&
                              (chatroom as GroupChat).groupType ==
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
                      InkWell(
                        onTap: () {
                          // Note to future implementers:
                          // This will be check security number
                        },
                        child: ListTile(
                          leading: const SizedBox(
                            height: double.infinity,
                            child: Icon(Icons.verified_user_outlined,
                                color: Colors.black),
                          ),
                          title: const Text(
                            "End-to-End Encryption",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "All messages are end-to-end encrypted.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 2, indent: 8, endIndent: 8),
                      // Shared Media (to be Implemented)
                      /*
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
                                          if (index > 0) ...[
                                            const SizedBox(width: 8)
                                          ],
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
                      */
                      // Group members
                      (chatroom.type == ChatroomType.group)
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
                      if (chatroom.type == ChatroomType.group)
                        //Group List View
                        Builder(builder: (_) {
                          final groupChat = chatroom as GroupChat;
                          return ListView.builder(
                              // +1 for add members
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: checkIsAdmin(userState)
                                  ? groupChat.members.length + 1
                                  : groupChat.members.length,
                              itemBuilder: (_, index) {
                                // Add member
                                if (index == 0 && checkIsAdmin(userState)) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => CreateGroupScreen(
                                          isCreateGroup: false,
                                          fromContactInfo: false,
                                          group: chatroom as GroupChat,
                                        ),
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
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
                                  onTapDown: (position) async {
                                    print((checkIsAdmin(userState)
                                            ? groupChat.members[index - 1]
                                            : groupChat.members[index])
                                        .id);
                                    print((await GroupMemberStore()
                                            .getbyChatroomIdAndUserId(
                                                chatroom.id,
                                                ((checkIsAdmin(userState)
                                                        ? groupChat
                                                            .members[index - 1]
                                                        : groupChat
                                                            .members[index])
                                                    .user
                                                    .userId)))!
                                        .id);
                                    return _getTapPosition(position);
                                  },
                                  onLongPress: () async {
                                    if (checkIsAdmin(userState) &&
                                        !(await checkSelfAccount(
                                            determineListViewIndexForCommonGroupList(
                                                userState,
                                                groupChat.members,
                                                index),
                                            index,
                                            userState))) {
                                      await _showContextMenu(
                                          context,
                                          groupChat.members[index - 1],
                                          userState);
                                    }
                                  },
                                  onTap: () async {
                                    /* direct to OneToOne chat */
                                    if (!(await checkSelfAccount(
                                        determineListViewIndexForCommonGroupList(
                                            userState,
                                            groupChat.members,
                                            index),
                                        index,
                                        userState))) {
                                      Chatroom? pmChatroom =
                                          await ChatroomStore().get(
                                              determineListViewIndexForCommonGroupList(
                                                      userState,
                                                      groupChat.members,
                                                      index)
                                                  .user
                                                  .userId);
                                      if (pmChatroom == null) {
                                        // havent have chatroom in the chatroom store but have contact in contact store
                                        // store chatroom in chatroom store
                                        pmChatroom = OneToOneChat(
                                          target:
                                              determineListViewIndexForCommonGroupList(
                                                      userState,
                                                      groupChat.members,
                                                      index)
                                                  .user,
                                          unread: 0,
                                          createdAt: DateTime.now(),
                                        );
                                        await ChatroomStore().save(pmChatroom);
                                      }
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ChatRoomScreen(
                                            chatroom: pmChatroom!),
                                        settings: RouteSettings(
                                            name: "/chatroom/${pmChatroom.id}"),
                                      ));
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        UserIcon(
                                          radius: 24,
                                          iconSize: 24,
                                          isGroup: false,
                                          profilePicUrl: (checkIsAdmin(
                                                      userState)
                                                  ? groupChat.members[index - 1]
                                                  : groupChat.members[index])
                                              .user
                                              .profilePicUrl,
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                            // isGroup ? _members[index].name : _common_group[index].name,
                                            ((checkIsAdmin(userState)
                                                            ? groupChat.members[
                                                                index - 1]
                                                            : groupChat
                                                                .members[index])
                                                        .user
                                                        .userId ==
                                                    userState.me!.userId)
                                                ? "You"
                                                : ((checkIsAdmin(userState)
                                                                ? groupChat
                                                                        .members[
                                                                    index - 1]
                                                                : groupChat
                                                                        .members[
                                                                    index])
                                                            .user
                                                            .displayName ==
                                                        null)
                                                    ? determineListViewIndexForCommonGroupList(
                                                            userState,
                                                            groupChat.members,
                                                            index)
                                                        .user
                                                        .username
                                                    : determineListViewIndexForCommonGroupList(
                                                            userState,
                                                            groupChat.members,
                                                            index)
                                                        .user
                                                        .displayName!,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const Expanded(child: SizedBox()),
                                        ((checkIsAdmin(userState)
                                                        ? groupChat
                                                            .members[index - 1]
                                                        : groupChat
                                                            .members[index])
                                                    .role ==
                                                Role.admin)
                                            ? const Icon(Icons.manage_accounts,
                                                size: 36,
                                                color: Colors.blueGrey)
                                            : Container(),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                      if (chatroom.type == ChatroomType.oneToOne)
                        // oneToOne Chatroom List View
                        FutureBuilder<List<Chatroom>>(
                            future: checkCommonGroupChat(chatroom, userState),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final chatrooms = snapshot.data!;
                              return ListView.builder(
                                  // +1 for add members / create group with the user
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: chatrooms.length,
                                  itemBuilder: (context, index) {
                                    // Common groups
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ChatRoomScreenGroup(
                                            chatroom:
                                                chatrooms[index] as GroupChat,
                                          ),
                                          settings: RouteSettings(
                                            name:
                                                "/chatroom-group/${chatrooms[index].id}",
                                          ),
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 16),
                                            UserIcon(
                                              radius: 24,
                                              iconSize: 24,
                                              isGroup: true,
                                              profilePicUrl: chatrooms[index]
                                                  .profilePicUrl,
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                                // isGroup ? _members[index].name : _common_group[index].name,
                                                chatrooms[index].name,
                                                style: const TextStyle(
                                                    fontSize: 16))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),

                      const Divider(thickness: 2, indent: 8, endIndent: 8),
                      // Block / Leave group
                      if ((chatroom.type == ChatroomType.group)) ...[
                        InkWell(
                          onTap: () {
                            /* confirm => process leave group */
                            _leaveGroupAlert(context);
                          },
                          child: const ListTile(
                            leading: Icon(Icons.exit_to_app,
                                size: 24, color: Colors.red),
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
                                  if (snapshot.hasData &&
                                      snapshot.data == false) {
                                    return AlertDialog(
                                      //Blocking button
                                      title:
                                          (chatroom.type == ChatroomType.group)
                                              ? const Text("Block group?")
                                              : const Text("Block user?"),
                                      content: (chatroom.type ==
                                              ChatroomType.group)
                                          ? const Text(
                                              "You will no longer be able to receive messages from this group.")
                                          : const Text(
                                              "You will no longer be able to receive messages from this user."),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            bool status = await BlockApi()
                                                .sendBlockRequest(chatroom.id);
                                            if (status) {
                                              //update blocked chatroom in blockstore
                                              await BlockStore()
                                                  .storeBlocked(chatroom.id);
                                            }
                                            Navigator.pop(context);
                                            Navigator.pop(context, chatroom);
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
                                          (chatroom.type == ChatroomType.group)
                                              ? const Text("Unblock group?")
                                              : const Text("Unblock user?"),
                                      content: (chatroom.type ==
                                              ChatroomType.group)
                                          ? const Text(
                                              "You will be able to receive messages from this group.")
                                          : const Text(
                                              "You will be able to receive messages from this user."),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            bool status = await BlockApi()
                                                .sendUnblockRequest(
                                                    chatroom.id);
                                            if (status) {
                                              //update chatroom in chatroomstore
                                              await BlockStore()
                                                  .removeBlocked(chatroom.id);
                                            }
                                            Navigator.pop(context);
                                            Navigator.pop(context, chatroom);
                                          },
                                          child: const Text("Unblock"),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return AlertDialog(
                                      //Blocking button
                                      title:
                                          (chatroom.type == ChatroomType.group)
                                              ? const Text("Block group?")
                                              : const Text("Block user?"),
                                      content: (chatroom.type ==
                                              ChatroomType.group)
                                          ? const Text(
                                              "You will no longer be able to receive messages from this group.")
                                          : const Text(
                                              "You will no longer be able to receive messages from this user."),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, chatroom),
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
                                  title: (snapshot.hasData &&
                                          snapshot.data == false)
                                      ? Text(
                                          "Block${(chatroom.type == ChatroomType.group) ? ' Group' : ''}",
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 18),
                                        )
                                      : Text(
                                          "Unblock${(chatroom.type == ChatroomType.group) ? ' Group' : ''}",
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
                                      "Block${(chatroom.type == ChatroomType.group) ? ' Group' : ''}",
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
            ));
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
                  chatroom.id, memberSelectedForTheAction.user.userId);
              //get newest info of member from server
              GroupMember memberfromAPI = await GroupChatApi().getGroupMember(
                  chatroom.id, memberSelectedForTheAction.user.userId);
              // await GroupMemberStore().save(
              //     chatroom.id,
              //     GroupMember(
              //         id: memberSelectedForTheAction.id,
              //         user: memberfromAPI.user,
              //         role: Role.admin));
              setState(() {
                (chatroom as GroupChat).members.removeWhere((element) =>
                    (element.user.userId ==
                        memberSelectedForTheAction.user.userId));
                (chatroom as GroupChat).members.add(GroupMember(
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
                  chatroom.id, memberSelectedForTheAction.user.userId);
              GroupMember memberfromAPI = await GroupChatApi().getGroupMember(
                  chatroom.id, memberSelectedForTheAction.user.userId);
              // await GroupMemberStore().save(
              //     chatroom.id,
              //     GroupMember(
              //         id: memberSelectedForTheAction.id,
              //         user: memberfromAPI.user,
              //         role: Role.member));
              setState(() {
                (chatroom as GroupChat).members.removeWhere((element) =>
                    (element.user.userId ==
                        memberSelectedForTheAction.user.userId));
                (chatroom as GroupChat).members.add(GroupMember(
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
                  chatroom.id, memberSelectedForTheAction.user.userId);
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
        bool leaveGroupSuccess = await GroupChatApi().leaveGroup(chatroom.id);
        //return to home screen (delete if unnecessary)
        if (leaveGroupSuccess) {
          ChatroomStore().remove(chatroom.id);
          (chatroom as GroupChat).members.clear();
          Navigator.pop(context, chatroom);
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
