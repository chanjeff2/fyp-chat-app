import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/settings/chat_screen.dart';
import 'package:fyp_chat_app/screens/settings/notification_screen.dart';
import 'package:fyp_chat_app/screens/settings/profile_screen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const account = "Account";
  static const privacy = "Privacy";
  static const chat = "Chat";
  static const notifications = "Notifications";

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
        builder: (context, userState, child) => Scaffold(
              appBar: AppBar(
                title: const Text("Settings"),
              ),
              body: Column(
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const SizedBox(
                          height: double.infinity,
                          child: CircleAvatar(
                            // child: profilePicture ? null : Icon(Icons.person, size: 48),
                            child: Icon(Icons.person,
                                size: 48, color: Colors.white),
                            radius: 32,
                            backgroundColor: Colors.blueGrey,
                          ),
                        ),
                        title: Text(
                          userState.me!.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          userState.me!.status 
                          ?? "Hi! I'm using USTalk.", // Status
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 2, indent: 8, endIndent: 8),
                  _renderOption(account, Icons.account_box, context),
                  _renderOption(privacy, Icons.lock, context),
                  const Divider(thickness: 2, indent: 8, endIndent: 8),
                  _renderOption(chat, Icons.chat, context),
                  _renderOption(notifications, Icons.notifications, context),
                ],
              ),
            ));
  }

  InkWell _renderOption(String title, IconData iconData, BuildContext context) {
    return InkWell(
        onTap: () => _onSettingsSelected(title, context),
        child: ListTile(
          leading: Icon(iconData, color: Colors.black),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ));
  }

  _onSettingsSelected(String title, BuildContext context) {
    switch (title) {
      case account:
        {
          return Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileScreen()));
        }
      case privacy:
        {
          print("Privacy");
          break;
        }
      case chat:
        {
          return Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ChatScreen()));
        }
      case notifications:
        {
          return Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const NotificationScreen()));
        }
    }
  }
}
