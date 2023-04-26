import 'package:json_annotation/json_annotation.dart';

import '../dto/user_dto.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  static const String createTableCommandFields = """
$columnUserId TEXT PRIMARY KEY NOT NULL, 
$columnUsername TEXT UNIQUE NOT NULL, 
$columnDisplayName TEXT,
$columnStatus TEXT,
$columnProfilePicUrl TEXT,
$columnUpdatedAt TEXT NOT NULL
""";

  static const columnUserId = "userId";
  @JsonKey(required: true, name: columnUserId)
  final String userId;

  static const columnUsername = "username";
  @JsonKey(required: true, name: columnUsername)
  final String username;

  static const columnDisplayName = "displayName";
  @JsonKey(name: columnDisplayName)
  final String? displayName;

  static const columnStatus = "status";
  @JsonKey(name: columnStatus)
  final String? status;

  static const columnProfilePicUrl = "profilePicUrl";
  @JsonKey(name: columnProfilePicUrl)
  final String? profilePicUrl;

  static const columnUpdatedAt = "updatedAt";
  @JsonKey(name: columnUpdatedAt)
  final String updatedAt;

  UserEntity({
    required this.userId,
    required this.username,
    this.displayName,
    this.status,
    this.profilePicUrl,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
