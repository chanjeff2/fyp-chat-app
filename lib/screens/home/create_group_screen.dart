import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:intl/intl.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends State<CreateGroupScreen> {
  final Map<String, Chatroom> _chatroomMap = {};
  late final Future<bool> _loadChatroomFuture;
  List<bool> _isChecked = [];

  void initState() {
    super.initState();
    _loadChatroomFuture = _loadChatroom();
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
          final chatroomList = _chatroomMap.values.toList();
          chatroomList.sort((a, b) => a.compareByLastActivityTime(b) * -1);
          var filterList = chatroomList
              .where((i) => i.type == ChatroomType.oneToOne)
              .toList();
          _isChecked = List.filled(filterList.length, false);
          return ListView.builder(
            itemBuilder: (_, i) => GroupContact(
              chatroom: filterList[i],
              onClick: () {},
            ),
            itemCount: filterList.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
    );
  }
}

class GroupContact extends StatelessWidget {
  const GroupContact({
    Key? key,
    required this.chatroom,
    this.onClick,
  }) : super(key: key); // Require session?
  final Chatroom chatroom;
  final VoidCallback? onClick;

  String updateDateTime(DateTime latestActivityTime) {
    DateTime now = DateTime.now();
    DateTime dayBegin = DateTime(now.year, now.month, now.day);
    final diff = dayBegin.difference(latestActivityTime).inDays;
    if (diff < 1) {
      return "${latestActivityTime.hour.toString().padLeft(2, '0')}:${latestActivityTime.minute.toString().padLeft(2, '0')}";
    }
    if (diff == 1) {
      return "Yesterday";
    }
    if (diff > 1) {
      return "${latestActivityTime.day.toString()}/${latestActivityTime.month.toString()}/${latestActivityTime.year.toString()}";
    }
    return "HOW?";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person, size: 28, color: Colors.white),
            radius: 28,
            backgroundColor: Colors.blueGrey,
          ),
          title: Row(
            children: [
              Text(
                chatroom.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
