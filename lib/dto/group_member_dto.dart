import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_member_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupMemberDto {
  @JsonKey(required: true)
  UserDto user;

  @JsonKey(required: true)
  Role role;

  GroupMemberDto({
    required this.user,
    required this.role,
  });

  Map<String, dynamic> toJson() => _$GroupMemberDtoToJson(this);

  factory GroupMemberDto.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberDtoFromJson(json);
}


