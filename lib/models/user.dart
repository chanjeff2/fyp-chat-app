import 'package:json_annotation/json_annotation.dart';

import '../dto/user_dto.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  static const String createTableCommandFields =
      "$columnUserId TEXT PRIMARY KEY, $columnUsername TEXT UNIQUE, $columnDisplayName TEXT";

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnUsername = "username";
  @JsonKey(required: true, name: columnUsername)
  final String username;

  static const columnDisplayName = "displayName";
  @JsonKey(name: columnDisplayName)
  final String? displayName;

  String get name => displayName ?? username;

  User({
    required this.userId,
    required this.username,
    this.displayName,
  });

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  User.fromDto(UserDto dto)
      : userId = dto.userId,
        username = dto.username,
        displayName = dto.displayName;
}
