import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/chatroom.dart';
import 'package:fyp_chat_app/models/user.dart';

class ReceivedPlainMessage {
  final User sender;
  final Chatroom chatroom;
  final ChatMessage message;

  ReceivedPlainMessage({
    required this.sender,
    required this.chatroom,
    required this.message,
  });
}
