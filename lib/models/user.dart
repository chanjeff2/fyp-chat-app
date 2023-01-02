import 'package:json_annotation/json_annotation.dart';

import '../dto/user_dto.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  static const String createTableCommandFields =
      "$columnUserId TEXT PRIMARY KEY, $columnUsername TEXT UNIQUE";

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnUsername = "username";
  @JsonKey(required: true, name: columnUsername)
  final String username;

  User(this.userId, this.username);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  User.fromDto(UserDto dto)
      : userId = dto.userId,
        username = dto.username;
}
