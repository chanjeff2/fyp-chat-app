import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_chat_app/firebase/fcm_handler.dart';
import 'package:fyp_chat_app/models/user_state.dart';
import 'package:fyp_chat_app/screens/home/home_screen.dart';
import 'package:fyp_chat_app/screens/register_or_login/register_or_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:fyp_chat_app/components/palette.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) {
  return FCMHandler.onBackgroundMessage(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // handle message received on background
  FirebaseMessaging.onBackgroundMessage(FCMHandler.onBackgroundMessage);

  FlutterNativeSplash.remove();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // handle fcm message
    // handle message received on foreground
    FirebaseMessaging.onMessage.listen(
      (message) => FCMHandler.onForegroundMessage(
        Provider.of<UserState>(context, listen: false),
        message,
      ),
    );
    setUpFCMInteractedMessage();
  }

  Future<void> setUpFCMNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      FCMHandler.channelId, // id
      FCMHandler.channelName, // title
      description: FCMHandler.channelDescription, // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = const AndroidInitializationSettings("ic_launcher");
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
      );
    
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> setUpFCMInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // handle the message
    if (initialMessage != null) {
      FCMHandler.onMessageOpenedApp(initialMessage);
    }

    // when the app is opened from background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(FCMHandler.onMessageOpenedApp);
  }

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
