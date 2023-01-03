import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom.dart';

// Contact in selecting user, which shows status
class ContactOption extends StatelessWidget {
  const ContactOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatRoomScreen()
                   )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: const [
          SizedBox(width: 16.0),
          CircleAvatar(
            child: Icon(Icons.person, size: 28, color: Colors.white),
            radius: 28,
            backgroundColor: Colors.blueGrey,
          ),
          SizedBox(width: 12.0),
          Text(
            'Test user', // '${user.displayName ?? user.username}'
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}

// Contact in home page, which shows latest message and timestamp
class HomeContact extends StatelessWidget {
  const HomeContact({Key? key,
                      required this.contactInfo,
                      required this.latestMessage,
                      required this.notifications,
                    }) : super(key: key); // Require session?
  final User contactInfo;
  final int notifications;
  final PlainMessage latestMessage;

  DateTime get latestActivityTime => latestMessage.sentAt;
  String get messageContent => latestMessage.content;
  bool get isFromMe => contactInfo.userId == latestMessage.recipientUserId;
  
  String parseNotifications(int notifications) {
    if (notifications > 9) {
      return "9+";
    } else {
      return notifications.toString();
    }
  }

  String updateDateTime(DateTime latestActivityTime) {
    DateTime now = DateTime.now();
    DateTime dayBegin = DateTime(now.year, now.month, now.day);
    final diff = dayBegin.difference(latestActivityTime).inDays;
    if (diff < 1) {
      return "${latestActivityTime.hour.toString().padLeft(2,'0')}:${latestActivityTime.minute.toString().padLeft(2,'0')}";
    }
    if (diff == 1) {
      return "Yesterday";
    }
    if (diff > 1) {
      return "${latestActivityTime.day.toString()}/${latestActivityTime.month.toString()}/${latestActivityTime.year.toString()}";
    }
    return "HOW?";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatRoomScreen()
                   )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            const CircleAvatar(
              child: Icon(Icons.person, size: 28, color: Colors.white),
              radius: 28,
              backgroundColor: Colors.blueGrey,
            ),
            const SizedBox(width: 12.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                Text(
                  contactInfo.displayName ?? contactInfo.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  latestMessage.content, // Latest message
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  updateDateTime(latestActivityTime), // time
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: (notifications > 0) ? Colors.redAccent : Colors.black,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (notifications > 0) ? Colors.redAccent : null, // Theme.of(context).primaryColor,
                  ),
                  child: (notifications > 0) ? Text(
                    parseNotifications(notifications),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ) : null,
                ),
              ],
            ),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
    );
  }
}
