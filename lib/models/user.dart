import 'package:fyp_chat_app/entities/user_entity.dart';

import '../dto/user_dto.dart';

class User {
  final String userId;
  final String username;
  final String? displayName;
  final String? status;

  String get name => displayName ?? username;

  User({
    required this.userId,
    required this.username,
    this.displayName,
    this.status,
  });

  User.fromDto(UserDto dto)
      : userId = dto.userId,
        username = dto.username,
        displayName = dto.displayName,
        status = dto.status;

  User.fromEntity(UserEntity entity)
      : userId = entity.userId,
        username = entity.username,
        displayName = entity.displayName,
        status = entity.status;

  UserEntity toEntity() => UserEntity(
        userId: userId,
        username: username,
        displayName: displayName,
        status: status,
      );
}
