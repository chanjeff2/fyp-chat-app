import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/home/home_screen.dart';
import 'package:fyp_chat_app/screens/register_or_login/register_or_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/components/palette.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Palette.ustBlue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        if (!userState.isInitialized) {
          // return loading screen
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!userState.isLoggedIn) {
          return const RegisterOrLoginScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
