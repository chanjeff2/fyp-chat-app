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

  String createdAt;

  GroupDto({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$GroupDtoToJson(this);

  factory GroupDto.fromJson(Map<String, dynamic> json) =>
      _$GroupDtoFromJson(json);
}
