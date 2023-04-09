import 'package:flutter/material.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:intl/intl.dart';

// Contact in selecting user, which shows status
class ContactOption extends StatelessWidget {
  const ContactOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //  onTap: () => Navigator.of(context).push(MaterialPageRoute(
      //               builder: (context) => const ChatRoomScreen()
      //              )),
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
  const HomeContact({
    Key? key,
    required this.chatroom,
    this.onClick,
  }) : super(key: key); // Require session?
  final Chatroom chatroom;
  final VoidCallback? onClick;

  String updateDateTime(DateTime latestActivityTime) {
    DateTime now = DateTime.now();
    DateTime dayBegin = DateTime(now.year, now.month, now.day);
    final diff = dayBegin.difference(latestActivityTime).inDays;
    if (diff < 1) {
      return "${latestActivityTime.hour.toString().padLeft(2, '0')}:${latestActivityTime.minute.toString().padLeft(2, '0')}";
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
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person, size: 28, color: Colors.white),
            radius: 28,
            backgroundColor: Colors.blueGrey,
          ),
          title: Row(
            children: [
              Text(
                chatroom.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (chatroom.latestMessage != null)
                Text(
                  DateFormat.Hm()
                      .format(chatroom.latestMessage!.sentAt), // time
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        (chatroom.unread > 0) ? Colors.redAccent : Colors.black,
                  ),
                ),
            ],
          ),
          subtitle: Row(
            children: [
              if (chatroom.latestMessage != null)
                Expanded(
                  child: Text(
                    chatroom.latestMessage!.content, // Latest message
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              const Spacer(),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (chatroom.unread > 0)
                      ? Colors.redAccent
                      : null, // Theme.of(context).primaryColor,
                ),
                child: (chatroom.unread > 0)
                    ? Text(
                        chatroom.unread > 9 ? '9+' : chatroom.unread.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
