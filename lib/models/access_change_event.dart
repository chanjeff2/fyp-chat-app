import 'package:fyp_chat_app/dto/events/access_control_event_dto.dart';
import 'package:fyp_chat_app/models/chat_event.dart';
import 'package:fyp_chat_app/models/enum.dart';

class AccessControlEvent extends ChatroomEvent {
  final String targetUserId;

  AccessControlEvent({
    required FCMEventType type,
    required String senderUserId,
    required String chatroomId,
    required DateTime sentAt,
    required this.targetUserId,
  }) : super(
          type: type,
          senderUserId: senderUserId,
          chatroomId: chatroomId,
          sentAt: sentAt,
        );

  AccessControlEvent.fromDto(AccessControlEventDto dto)
      : targetUserId = dto.targetUserId,
        super(
            type: dto.type,
            senderUserId: dto.senderUserId,
            chatroomId: dto.chatroomId,
            sentAt: DateTime.parse(dto.sentAt));
}
