import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/account.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:provider/provider.dart';

import '../../network/account_api.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
                                  title: Text("Mute All Notifications"),
                                  content: Text(
                                      "This action will mute notifications from all the chats. Are you sure to perform this action?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
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
                                  title: Text("Enable All Notifications"),
                                  content: Text(
                                      "This action will enable back to recieve notifications from all the chats. Are you sure to perform this action?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
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
