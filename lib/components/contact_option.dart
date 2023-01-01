import 'package:flutter/material.dart';
import 'package:fyp_chat_app/screens/chatroom/chatroom.dart';

// Contact in selecting user, which shows status
class ContactOption extends StatelessWidget {
  const ContactOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Contact in home page, which shows latest message and timestamp
class HomeContact extends StatelessWidget {
  const HomeContact({Key? key, required this.notifications}) : super(key: key); // Require session?
  final int notifications;

  String parseNotifications(int notifications) {
    if (notifications > 9) {
      return "9+";
    } else {
      return notifications.toString();
    }
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
              children: const <Text>[
                Text(
                  'Test user', // '${user.displayName ?? user.username}'
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hello!", // Latest message
                  style: TextStyle(
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
                  '12:34', // time
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