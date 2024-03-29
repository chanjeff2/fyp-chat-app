import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/components/user_icon.dart';
import 'package:fyp_chat_app/dto/create_group_dto.dart';
import 'package:fyp_chat_app/dto/group_member_dto.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_member.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:fyp_chat_app/storage/group_member_store.dart';
import 'package:provider/provider.dart';

import '../../models/group_chat.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({
    Key? key,
    this.onNewChatroom,
    required this.isCreateGroup,
    required this.fromContactInfo,
    this.group,
  }) : super(key: key);
  final void Function(Chatroom)? onNewChatroom;
  final bool isCreateGroup;
  final bool fromContactInfo;
  final GroupChat? group;
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends State<CreateGroupScreen> {
  final Map<String, Chatroom> _chatroomMap = {};
  late final Future<bool> _loadChatroomFuture;
  List<bool> isChecked = [];
  List<Chatroom> outputArray = [];
  List<Chatroom> filterList = [];
  late final GroupChat group;
  late TextEditingController addContactController;

  @override
  void initState() {
    super.initState();
    _loadChatroomFuture = _loadChatroom();
    addContactController = TextEditingController();
    //assgin the group already created
    if (widget.isCreateGroup == false) {
      group = widget.group!;
    }
  }

  @override
  void dispose() {
    addContactController.dispose();
    super.dispose();
  }

  Future<bool> _loadChatroom() async {
    final chatroomList = await ChatroomStore().getAllChatroom();
    setState(() {
      _chatroomMap.addEntries(chatroomList.map((e) => MapEntry(e.id, e)));
    });
    final listOfRooms = _chatroomMap.values.toList();
    listOfRooms.sort((a, b) => a.compareByLastActivityTime(b) * -1);
    filterList =
        listOfRooms.where((i) => i.type == ChatroomType.oneToOne).toList();
    // further filter when that user is already in group
    if (widget.isCreateGroup == false) {
      filterList = filterList
          // TODO: debug
          .where((element) => !(alreadyInGroup(element, group.members)))
          .toList();
    }
    setState(() {
      isChecked = List.filled(filterList.length, false);
    });
    return true;
  }

  bool alreadyInGroup(Chatroom target, List<GroupMember> memberList) {
    for (var i in memberList) {
      if (i.user.userId == target.id) {
        return true;
      }
    }
    return false;
  }

  Future<String?> inputDialog(String title, String hint) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: hint),
            controller: addContactController,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(addContactController.text);
                  addContactController.clear();
                },
                child: const Text('Submit'))
          ],
        ),
      );

  Future<void> inviteMemberToGroup(
      List<Chatroom> members, String groupId) async {
    try {
      for (var element in members) {
        GroupChatApi()
            .inviteMember(groupId, (element as OneToOneChat).target.userId);
      }
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("error: ${e.message}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
        builder: (context, userState, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                    widget.isCreateGroup ? "Create Group" : "Add new user"),
              ),
              body: FutureBuilder<bool>(
                future: _loadChatroomFuture,
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  //list of contact
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            isChecked[index] = !(isChecked[index]);
                          });
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          tileColor: isChecked[index]
                              ? Palette.ustGrey[500]
                              : Colors.white,
                          leading: UserIcon(
                            radius: 28,
                            iconSize: 28,
                            isGroup: false,
                            profilePicUrl: filterList[index].profilePicUrl,
                          ),
                          title: Text(
                            filterList[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            (filterList[index] as OneToOneChat).target.status ??
                                "Hi! I'm using USTalk.", // Status
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: filterList.length,
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  outputArray = filterList
                      .where(
                          (element) => isChecked[filterList.indexOf(element)])
                      .toList();
                  if (widget.isCreateGroup) {
                    final name = await inputDialog(
                      "Add Group",
                      "Please enter the Group name",
                    );
                    if (name == null || name.isEmpty) return;
                    //create group
                    try {
                      group = await GroupChatApi()
                          .createGroup(CreateGroupDto(name: name));
                    } on ApiException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("error: ${e.message}")));
                    }
                    await ChatroomStore().save(group);

                    // callback and return to home
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                    widget.onNewChatroom?.call(group);
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                  // TODO : debug
                  inviteMemberToGroup(outputArray, group.id);
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ));
  }
}
