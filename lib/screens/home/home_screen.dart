import 'dart:math'; // For testing purposes, delete later

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/contact_option.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/home/select_contact.dart';
import 'package:fyp_chat_app/screens/settings/settings_screen.dart';
import 'package:fyp_chat_app/storage/credential_store.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {  
  var appBarHeight = AppBar().preferredSize.height;
  var _rng = new Random();
  final List<Widget> _contacts = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) => Scaffold(
        appBar: AppBar(
          title: const Text("USTalk"),
          actions: [
            IconButton(onPressed: () {
                setState(() {
                  _contacts.insert(0, HomeContact(notifications: _rng.nextInt(15)));
                });
              },
              icon: const Icon(Icons.add),
            ),
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
                _buildPopupMenuItem('  Settings', Icons.settings, 0),
                _buildPopupMenuItem('  Logout', Icons.logout, 1),
              ],
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: _contacts.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: <Widget>[
              if (_contacts.isEmpty)
              ...[Text('Hi ${userState.me!.displayName ?? userState.me!.username}. You have no contacts')]
              else ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) => _contacts[index],
                  )
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(_route(const SelectContact())),
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

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
      child:  Row(
        children: [
          Icon(iconData, color: Colors.black,),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value, UserState userState) {
    switch (value) {
      case 0: {
        Navigator.of(context).push(_route(const SettingsScreen()));
        break;
      }
      case 1: {
        CredentialStore().removeCredential();
        userState.clearState();
        break;
      }
    }
  }
}
