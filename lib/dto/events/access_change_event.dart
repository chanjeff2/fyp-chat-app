import 'package:fyp_chat_app/dto/events/chatroom_event.dart';
import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class AccessChangeEvent extends ChatroomEvent {
  @JsonKey(required: true)
  final String recipientUserId;

  AccessChangeEvent({
    required EventType type,
    required String senderUserId,
    required String chatroomId,
    required String sentAt,
    required this.recipientUserId,
  }) : super(
          type: type,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );
}
