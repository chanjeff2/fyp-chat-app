import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/user.dart';

import 'chatroom_event.dart';

class ReceivedChatEvent {
  final User sender;
  final Chatroom chatroom;
  final ChatroomEvent event;

  ReceivedChatEvent({
    required this.sender,
    required this.chatroom,
    required this.event,
  });
}
