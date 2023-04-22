import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'group_member_dto.dart';

part 'group_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupDto {
  @JsonKey(required: true, name: "_id")
  String id;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  List<GroupMemberDto> members;

  @JsonKey(required: true)
  String createdAt;

  @JsonKey(required: true)
  GroupType groupType;

  @JsonKey(required: false)
  String? description;

  @JsonKey(required: false)
  String? profilePicUrl;

  GroupDto({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
    required this.groupType,
    this.description,
    this.profilePicUrl,
  });

  Map<String, dynamic> toJson() => _$GroupDtoToJson(this);

  factory GroupDto.fromJson(Map<String, dynamic> json) =>
      _$GroupDtoFromJson(json);
}
