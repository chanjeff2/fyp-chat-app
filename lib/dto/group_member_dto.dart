import 'package:fyp_chat_app/dto/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_member_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupMemberDto {
  @JsonKey(required: true, name: "_id")
  UserDto user;

  @JsonKey(required: true)
  Role role;

  @JsonKey(required: true)
  List<GroupMemberDto> members;

  GroupMemberDto({
    required this.user,
    required this.role,
    required this.members,
  });

  Map<String, dynamic> toJson() => _$GroupMemberDtoToJson(this);

  factory GroupMemberDto.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberDtoFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum Role {
  member,
  admin,
}
