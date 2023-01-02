import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/user.dart';

class ReceivedPlainMessage {
  final User sender;
  final PlainMessage message;

  ReceivedPlainMessage({
    required this.sender,
    required this.message,
  });
}
