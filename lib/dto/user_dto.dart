import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(required: true)
  String userId;

  @JsonKey(required: true)
  String username;

  @JsonKey()
  String? displayName;

  @JsonKey()
  String? status;

  @JsonKey()
  String? profilePicUrl;

  @JsonKey()
  String updatedAt;

  UserDto({
    required this.userId,
    required this.username,
    this.displayName,
    this.status,
    this.profilePicUrl,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
