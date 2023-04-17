import 'package:json_annotation/json_annotation.dart';

part 'create_group_dto.g.dart';

@JsonSerializable()
class CreateGroupDto {
  @JsonKey(required: true)
  String name;

  CreateGroupDto({
    required this.name,
  });

  Map<String, dynamic> toJson() => _$CreateGroupDtoToJson(this);

  factory CreateGroupDto.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupDtoFromJson(json);
}
