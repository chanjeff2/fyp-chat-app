import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/default_option.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/network/api.dart';
import 'package:fyp_chat_app/network/users_api.dart';
import 'package:fyp_chat_app/screens/chatroom/join_course_group_screen.dart';
import 'package:fyp_chat_app/screens/home/create_group_screen.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';

import '../../storage/contact_store.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({
    Key? key,
    this.onNewChatroom,
  }) : super(key: key);
  final void Function(Chatroom)? onNewChatroom;

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  final List<Contact> _contacts = [];

  String addContactInput = "";

  late TextEditingController addContactController;

  @override
  void initState() {
    // Add default items to list

    super.initState();

    addContactController = TextEditingController();
  }

  //dispose the add contact controller
  @override
  void dispose() {
    addContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Contact"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
              itemCount: _contacts.length + 3,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return InkWell(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateGroupScreen(
                            onNewChatroom: widget.onNewChatroom,
                            isCreateGroup: true,
                            fromContactInfo: false,
                          ),
                        ));
                      },
                      child: const DefaultOption(
                        icon: Icons.group_add,
                        name: "Create group",
                      ),
                    );

                  case 1:
                    // add content
                    return InkWell(
                      onTap: () async {
                        //Pop up screen for add content
                        final name = await inputDialog(
                          "Add Contact",
                          "Please enter their username",
                        );
                        if (name == null || name.isEmpty) return;
                        setState(() {
                          addContactInput = name;
                        });
                        //add the user to local storage contact
                        try {
                          User addUser = await UsersApi()
                              .getUserByUsername(addContactInput);
                          // local storage on disk
                          await ContactStore().storeContact(addUser);
                          final chatroom = OneToOneChat(
                            target: addUser,
                            unread: 0,
                            createdAt: DateTime.now(),
                          );
                          await ChatroomStore().save(chatroom);
                          // callback and return to home
                          Navigator.of(context).pop();
                          widget.onNewChatroom?.call(chatroom);
                          //print(_contacts.length);
                        } on ApiException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("error: ${e.message}")));
                        }
                      },
                      child: const DefaultOption(
                        icon: Icons.person_add,
                        name: "Add contact",
                      ),
                    );

                  case 2:
                    //TODO: add to course group
                    return InkWell(
                      onTap: () async {
                        // final course = await inputDialog(
                        //   "Join a course group",
                        //   "Please enter course code",
                        // );
                        // if (course == null || course.isEmpty) return;
                        // //late final GroupChat group;
                        // try {
                        //   //TODO: send join request to server
                        //   // group = await GroupChatApi()
                        //   //     .createGroup(CreateGroupDto(name: name));
                        // } on ApiException catch (e) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text("error: ${e.message}")));
                        // }
                        // // await ChatroomStore().save(group);
                        // // callback and return to home
                        // Navigator.of(context).pop();
                        // // widget.onNewChatroom?.call(group);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const JoinCourseGroupScreen(),
                        ));
                      },
                      child: const DefaultOption(
                        icon: Icons.group_add,
                        name: "Join a course group",
                      ),
                    );

                  case 3:
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        "Groups in USTalk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );

                  default:
                    return const ContactOption();
                }
              }),
        ));
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
}

// modal class for Contact, can remove later
class Contact {
  String username, /*status,*/ id;
  //Image img;
  Contact({
    required this.username,
    //required this.status,
    required this.id,
    //required this.img
  });
}
