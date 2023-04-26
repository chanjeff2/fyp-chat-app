import 'package:fyp_chat_app/models/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_info_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupInfoDto {
  @JsonKey(required: true, name: "_id")
  String id;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  String updatedAt;

  @JsonKey(required: true)
  String createdAt;

  @JsonKey(required: true)
  GroupType groupType;

  @JsonKey(required: false)
  String? description;

  @JsonKey(required: false)
  String? profilePicUrl;

  GroupInfoDto({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.groupType,
    this.description,
    this.profilePicUrl,
  });

  Map<String, dynamic> toJson() => _$GroupInfoDtoToJson(this);

  factory GroupInfoDto.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoDtoFromJson(json);
}
