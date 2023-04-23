import 'package:fyp_chat_app/dto/group_info_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'group_member_dto.dart';

part 'group_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupDto extends GroupInfoDto {
  @JsonKey(required: true)
  List<GroupMemberDto> members;

  GroupDto({
    required String id,
    required String name,
    required this.members,
    required String createdAt,
    required GroupType groupType,
    String? description,
    String? profilePicUrl,
  }) : super(
          id: id,
          name: name,
          createdAt: createdAt,
          groupType: groupType,
          description: description,
          profilePicUrl: profilePicUrl,
        );

  @override
  Map<String, dynamic> toJson() => _$GroupDtoToJson(this);

  factory GroupDto.fromJson(Map<String, dynamic> json) =>
      _$GroupDtoFromJson(json);
}
