// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatroomEntity _$ChatroomEntityFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'type', 'name'],
  );
  return ChatroomEntity(
    id: json['id'] as String,
    type: json['type'] as int,
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$ChatroomEntityToJson(ChatroomEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
    };
