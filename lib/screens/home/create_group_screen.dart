import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
  List<bool?> isChecked = [];
  List<String> outputArray = [];
  List<Chatroom> filterList = [];

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
          filterList = chatroomList
              .where((i) => i.type == ChatroomType.oneToOne)
              .toList();
          isChecked = List.filled(filterList.length, false);
          return ListView.builder(
            itemBuilder: (context, index) {
              return Ink(
                color: isChecked[index]! ? Colors.black : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    tileColor: isChecked[index]! ? Colors.black : Colors.white,
                    onTap: () {
                      isChecked[index] = !(isChecked[index]!);
                      print(isChecked[index]);
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.person, size: 28, color: Colors.white),
                      radius: 28,
                      backgroundColor: Colors.blueGrey,
                    ),
                    title: Row(
                      children: [
                        Text(
                          filterList[index].name,
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
            },
            itemCount: filterList.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          outputArray = filterList
              .where((element) =>
                isChecked[filterList.indexOf(element)]!
              )
              .map(((e) => e.name))
              .toList();
          print(outputArray);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

