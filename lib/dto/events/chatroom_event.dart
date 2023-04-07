import 'package:fyp_chat_app/dto/events/fcm_event.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ChatroomEvent extends FCMEvent {
  @JsonKey(required: true)
  final String senderUserId;

  @JsonKey(required: true)
  final String chatroomId;

  @JsonKey(required: true)
  final String sentAt; // iso string

  ChatroomEvent({
    required EventType type,
    required this.senderUserId,
    required this.chatroomId,
    required this.sentAt,
  }) : super(type);
}
