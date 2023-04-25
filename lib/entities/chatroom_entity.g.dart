// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatroomEntity _$ChatroomEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'type', 'createdAt', 'groupType'],
  );
  return ChatroomEntity(
    id: json['id'] as String,
    type: json['type'] as int,
    name: json['name'] as String?,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String?,
    groupType: json['groupType'] as int?,
    description: json['description'] as String?,
    profilePicUrl: json['profilePicUrl'] as String?,
    isMuted: json['isMuted'] as int? ?? 0,
  );
}

Map<String, dynamic> _$ChatroomEntityToJson(ChatroomEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'groupType': instance.groupType,
      'description': instance.description,
      'profilePicUrl': instance.profilePicUrl,
      'isMuted': instance.isMuted,
    };
