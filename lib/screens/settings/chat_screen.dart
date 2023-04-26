import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:provider/provider.dart';

import '../../network/account_api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // Add default items to list

    super.initState();
  }

  //dispose the add contact controller
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
        builder: (context, userState, child) => Scaffold(
              appBar: AppBar(
                title: const Text("Chat"),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: const Text("Delete all chatrooms"),
                                  content: const Text(
                                      "This action will delete all messages history and chatroom in your storage. Are you sure to perform this action?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        var list = await ChatroomStore()
                                            .getAllChatroom();
                                        //for each element in list, delete chatroom
                                        for (var element in list) {
                                          ChatroomStore().remove(element.id);
                                        }
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "All chatrooms deleted successfully")));
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ]);
                            });
                      },
                      child: const ListTile(
                        leading: SizedBox(
                          height: double.infinity,
                          child:
                              Icon(Icons.person, color: Colors.black, size: 30),
                        ),
                        title: Text(
                          "Delete all chatrooms",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Delete all chatrooms and messages history from your data storage",
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                  const Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              ),
            ));
  }
}
