import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/network/auth_api.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom.dart';
import 'package:fyp_chat_app/screens/home/select_contact.dart';
import 'package:fyp_chat_app/screens/settings/settings_screen.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:fyp_chat_app/storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var appBarHeight = AppBar().preferredSize.height;
  late final StreamController<List<User>> _contactStreamController;

  @override
  void initState() {
    super.initState();
    _contactStreamController = StreamController(onListen: () async {
      final contacts = await ContactStore().getAllContact();
      _contactStreamController.add(contacts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          title: const Text("USTalk"),
          actions: [
            IconButton(
              onPressed: () {
                print("Search - To be implemented");
              },
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton(
              offset: Offset(0.0, appBarHeight),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              onSelected: (value) {
                _onMenuItemSelected(value as int, userState);
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem('Settings', Icons.settings, 0),
                _buildPopupMenuItem('Logout', Icons.logout, 1),
              ],
            ),
          ],
        ),
        body: StreamBuilder<List<User>>(
          stream: _contactStreamController.stream,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final contacts = snapshot.data!;
            final _rng = Random();
            return ListView.builder(
              itemBuilder: (_, i) => HomeContact(
                user: contacts[i],
                unread: _rng.nextInt(15),
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ChatRoomScreen(targetUser: contacts[i])));
                },
              ),
              itemCount: contacts.length,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(_route(SelectContact(
              onNewContact: (contact) {
                _contactStreamController.add([contact]);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatRoomScreen(targetUser: contact)));
              },
            )));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Route _route(Widget screen) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  /* Codes of handling more menu items here */
  // Create a popup menu item that is in the form of Icon + text
  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int positon) {
    return PopupMenuItem(
      value: positon,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value, UserState userState) async {
    switch (value) {
      case 0:
        Navigator.of(context).push(_route(const SettingsScreen()));
        break;
      case 1:
        await DevicesApi().removeDevice();
        await AuthApi().logout();
        await CredentialStore().removeCredential();
        await DiskStorage().deleteDatabase();
        await SecureStorage().deleteAll();
        await (await SharedPreferences.getInstance()).clear();
        userState.clearState();
        break;
    }
  }
}
