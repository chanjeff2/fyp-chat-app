import 'package:flutter/material.dart';
import 'package:fyp_chat_app/components/user_icon.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:intl/intl.dart';

// Practically useless now, remake if needed
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
          leading: UserIcon(
            isGroup: chatroom.type == ChatroomType.group,
            profilePicUrl: chatroom.profilePicUrl,
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
                    fontWeight: (chatroom.unread > 0)
                        ? FontWeight.bold
                        : FontWeight.normal,
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
                    chatroom
                        .latestMessage!.notificationContent, // Latest message
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: (chatroom.unread > 0)
                            ? FontWeight.w700
                            : FontWeight.normal),
                  ),
                ),
              const Spacer(),
              Visibility(
                visible: chatroom.unread > 0,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent, // Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    chatroom.unread > 9 ? '9+' : chatroom.unread.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
