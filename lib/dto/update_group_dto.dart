import 'package:json_annotation/json_annotation.dart';

part 'update_group_dto.g.dart';

@JsonSerializable()
class UpdateGroupDto {
  @JsonKey(includeIfNull: false)
  String? name;

  @JsonKey(includeIfNull: false)
  String? description;

  @JsonKey(includeIfNull: false)
  bool? isPublic;

  UpdateGroupDto({
    this.name,
    this.description,
    this.isPublic,
  });

  Map<String, dynamic> toJson() => _$UpdateGroupDtoToJson(this);

  factory UpdateGroupDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupDtoFromJson(json);
}
