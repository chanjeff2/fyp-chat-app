import 'package:fyp_chat_app/entities/user_entity.dart';

import '../dto/user_dto.dart';

class User {
  final String userId;
  final String username;
  final String? displayName;
  final String? status;
  final String? profilePicUrl;

  String get name => displayName ?? username;
  String get id => userId;

  User({
    required this.userId,
    required this.username,
    this.displayName,
    this.status,
    this.profilePicUrl,
  });

  User.fromDto(UserDto dto)
      : userId = dto.userId,
        username = dto.username,
        displayName = dto.displayName,
        status = dto.status,
        profilePicUrl = dto.profilePicUrl;

  User.fromEntity(UserEntity entity)
      : userId = entity.userId,
        username = entity.username,
        displayName = entity.displayName,
        status = entity.status,
        profilePicUrl = entity.profilePicUrl;

  UserEntity toEntity() => UserEntity(
        userId: userId,
        username: username,
        displayName: displayName,
        status: status,
        profilePicUrl: profilePicUrl,
      );
}
