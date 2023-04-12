import 'package:json_annotation/json_annotation.dart';

part 'send_access_control_dto.g.dart';

@JsonSerializable()
class SendAccessControlDto {
  @JsonKey(required: true)
  String targetUserId;
  @JsonKey(required: true)
  FCMEventType type;
  @JsonKey(required: true)
  DateTime sentAt;

  SendAccessControlDto(
      {required this.targetUserId, required this.type, required this.sentAt});

  Map<String, dynamic> toJson() => _$SendAccessControlDtoToJson(this);
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.kebab)
enum FCMEventType {
  TextMessage,
  MediaMessage,
  PatchGroup,
  AddMember,
  KickMember,
  PromoteAdmin,
  DemoteAdmin,
  MemberJoin,
  MemberLeave,
}
