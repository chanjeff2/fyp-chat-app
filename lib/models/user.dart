import 'package:fyp_chat_app/entities/user_entity.dart';

import '../dto/user_dto.dart';

class User {
  final String userId;
  final String username;
  final String? displayName;

  String get name => displayName ?? username;

  User({
    required this.userId,
    required this.username,
    this.displayName,
  });

  User.fromDto(UserDto dto)
      : userId = dto.userId,
        username = dto.username,
        displayName = dto.displayName;

  User.fromEntity(UserEntity entity)
      : userId = entity.userId,
        username = entity.username,
        displayName = entity.displayName;

  UserEntity toEntity() => UserEntity(
        userId: userId,
        username: username,
        displayName: displayName,
      );
}
