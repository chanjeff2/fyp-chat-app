import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:fyp_chat_app/dto/create_group_dto.dart';
import 'package:fyp_chat_app/dto/send_invitation_dto.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/group_chat_api.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:intl/intl.dart';

import '../../models/group_chat.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({
    Key? key,
    this.onNewChatroom,
  }) : super(key: key);
  final void Function(Chatroom)? onNewChatroom;

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends State<CreateGroupScreen> {
  final Map<String, Chatroom> _chatroomMap = {};
  late final Future<bool> _loadChatroomFuture;
  List<bool> isChecked = [];
  List<String> outputArray = [];
  List<Chatroom> filterList = [];
  late TextEditingController addContactController;

  @override
  void initState() {
    super.initState();
    _loadChatroomFuture = _loadChatroom();
    addContactController = TextEditingController();
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
    setState(() {
      isChecked = List.filled(filterList.length, false);
    });
    return true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tileColor:
                      isChecked[index] ? Palette.ustGrey[500] : Colors.white,
                  leading: const CircleAvatar(
                    child: Icon(Icons.person, size: 28, color: Colors.white),
                    radius: 28,
                    backgroundColor: Colors.blueGrey,
                  ),
                  title: Text(
                    filterList[index].name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Hi! I'm using USTalk.", // Status
                    style: TextStyle(
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
              .where((element) => isChecked[filterList.indexOf(element)])
              .map(((e) => e.id))
              .toList();
          final name = await inputDialog(
            "Add Group",
            "Please enter the Group name",
          );
          if (name == null || name.isEmpty) return;
          // create group on server
          late final GroupChat group;
          //create group
          try {
            group =
                await GroupChatApi().createGroup(CreateGroupDto(name: name));
          } on ApiException catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("error: ${e.message}")));
          }
          await ChatroomStore().save(group);
          // callback and return to home
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          widget.onNewChatroom?.call(group);
          //print(group.id);
          //invite member
          try {
            for (var element in outputArray) {
              GroupChatApi().inviteMember(
                  group.id,
                  SendInvitationDto(
                      target: element,
                      sentAt: DateTime.now().toIso8601String()));
            }
          } on ApiException catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("error: ${e.message}")));
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
