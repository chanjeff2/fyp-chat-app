import 'package:json_annotation/json_annotation.dart';

part 'send_access_control_dto.g.dart';

@JsonSerializable()
class SendAccessControlDto {
  String targetUserId;
  String actionType;

  SendAccessControlDto({
    required this.targetUserId,
    required this.actionType,
  });

  Map<String, dynamic> toJson() => _$SendAccessControlDtoToJson(this);
}
/*
enum ActionType {
  AddMember = 'add-member',
  KickMember = 'kick-member',
  PromoteAdmin = 'promote-member',
  DemoteAdmin = 'demote-member',
}
*/