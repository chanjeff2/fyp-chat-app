import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/register_or_login/loading_screen.dart';
import 'package:fyp_chat_app/storage/chatroom_store.dart';
import 'package:provider/provider.dart';

import '../../network/account_api.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;
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
        builder: (context, userState, child) => _isLoading
            ? const LoadingScreen()
            : Scaffold(
                appBar: AppBar(
                  title: const Text("Notifications"),
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
                                    title: const Text("Mute All Notifications"),
                                    content: const Text(
                                        "This action will mute notifications from all the chats. Are you sure to perform this action?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await ChatroomStore()
                                              .updateMuteAllChatrooms(true);
                                          /*
                                          await ChatroomStore()
                                              .getAllChatroom()
                                              .then((value) async {
                                            for (var element in value) {
                                              if (element.type ==
                                                  ChatroomType.oneToOne) {
                                                await ChatroomStore().save(
                                                    OneToOneChat(
                                                        latestMessage: element
                                                            .latestMessage,
                                                        unread: element.unread,
                                                        createdAt:
                                                            element.createdAt,
                                                        isMuted: true,
                                                        target: (element
                                                                as OneToOneChat)
                                                            .target));
                                              } else {
                                                await ChatroomStore()
                                                    .save(GroupChat(
                                                  id: element.id,
                                                  name: element.name,
                                                  members:
                                                      (element as GroupChat)
                                                          .members,
                                                  groupType: element.groupType,
                                                  description:
                                                      element.description,
                                                  profilePicUrl:
                                                      element.profilePicUrl,
                                                  latestMessage:
                                                      element.latestMessage,
                                                  unread: element.unread,
                                                  createdAt: element.createdAt,
                                                  isMuted: true,
                                                  updatedAt: element.updatedAt,
                                                ));
                                              }
                                            }
                                          });
                                          */
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "All chatrooms muted successfully")));
                                        },
                                        child: const Text("Mute"),
                                      ),
                                    ]);
                              });
                        },
                        child: const ListTile(
                          leading: SizedBox(
                            height: double.infinity,
                            child: Icon(Icons.notifications_off_outlined,
                                color: Colors.black, size: 30),
                          ),
                          title: Text(
                            "Mute All Notifications",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          subtitle: Text(
                            "Mute notifications from all your groups and chats",
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                    const Divider(
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title:
                                        const Text("Enable All Notifications"),
                                    content: const Text(
                                        "This action will enable back to recieve notifications from all the chats. Are you sure to perform this action?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await ChatroomStore()
                                              .updateMuteAllChatrooms(false);
                                          /*
                                          await ChatroomStore()
                                              .getAllChatroom()
                                              .then((value) async {
                                            for (var element in value) {
                                              if (element.type ==
                                                  ChatroomType.oneToOne) {
                                                await ChatroomStore().save(
                                                    OneToOneChat(
                                                        latestMessage: element
                                                            .latestMessage,
                                                        unread: element.unread,
                                                        createdAt:
                                                            element.createdAt,
                                                        isMuted: false,
                                                        target: (element
                                                                as OneToOneChat)
                                                            .target));
                                              } else {
                                                await ChatroomStore()
                                                    .save(GroupChat(
                                                  id: element.id,
                                                  name: element.name,
                                                  members:
                                                      (element as GroupChat)
                                                          .members,
                                                  groupType: element.groupType,
                                                  description:
                                                      element.description,
                                                  profilePicUrl:
                                                      element.profilePicUrl,
                                                  latestMessage:
                                                      element.latestMessage,
                                                  unread: element.unread,
                                                  createdAt: element.createdAt,
                                                  isMuted: false,
                                                  updatedAt: element.updatedAt,
                                                ));
                                              }
                                            }
                                          });
                                          */
                                          Navigator.pop(context);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "All chatrooms unmuted successfully")));
                                        },
                                        child: const Text("Enable"),
                                      ),
                                    ]);
                              });
                        },
                        child: const ListTile(
                          leading: SizedBox(
                            height: double.infinity,
                            child: Icon(Icons.notifications_active_outlined,
                                color: Colors.black, size: 30),
                          ),
                          title: Text(
                            "Enable All Notifications",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          subtitle: Text(
                            "Enable notifications from all your groups and chats",
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
