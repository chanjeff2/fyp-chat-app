import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/entities/media_item_entity.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class MediaItem {
  String id;
  final Uint8List content;
  final MessageType type;
  final String ext;

  MediaItem({
    required this.id,
    required this.content,
    required this.type,
    required this.ext,
  });

  MediaItem.fromEntity(MediaItemEntity dto)
      : id = dto.id,
        content = Uint8List.fromList(dto.content) ,
        type = MessageType.values[dto.type],
        ext = dto.ext;

  MediaItemEntity toEntity() => MediaItemEntity(
        id: id,
        content: content.toList(),
        type: MessageType.values.indexOf(type),
        ext: ext,
      );
}