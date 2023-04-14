import 'package:fyp_chat_app/dto/message_to_server_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_message_dto.g.dart';

@JsonSerializable()
class SendMessageDto {
  @JsonKey(required: true)
  final int senderDeviceId;

  @JsonKey(required: true)
  final String recipientUserId;

  @JsonKey(required: true)
  final String chatroomId;

  @JsonKey(required: true)
  final List<MessageToServerDto> messages;

  @JsonKey(required: true)
  final String messageType;

  @JsonKey(required: true)
  final String sentAt; // iso string

  SendMessageDto({
    required this.senderDeviceId,
    required this.recipientUserId,
    required this.chatroomId,
    required this.messages,
    required this.messageType,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);
}
