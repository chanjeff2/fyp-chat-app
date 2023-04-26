import 'package:json_annotation/json_annotation.dart';

part 'update_user_dto.g.dart';

@JsonSerializable()
class UpdateUserDto {
  @JsonKey(includeIfNull: false)
  String? displayName;

  @JsonKey(includeIfNull: false)
  String? status;

  UpdateUserDto({
    this.displayName,
    this.status,
  });

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);
}
