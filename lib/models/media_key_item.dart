import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/media_key_item_dto.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class MediaKeyItem {
  final MessageType type;
  final String ext;
  final Uint8List aesKey;
  final Uint8List iv;
  final String mediaId;

  MediaKeyItem({
    required this.type,
    required this.ext,
    required this.aesKey,
    required this.iv,
    required this.mediaId,
  });

  MediaKeyItem.fromDto(MediaKeyItemDto dto)
      : type = MessageType.values[dto.type],
        ext = dto.ext,
        aesKey = Uint8List.fromList(dto.aesKey),
        iv = Uint8List.fromList(dto.iv),
        mediaId = dto.mediaId;

  MediaKeyItemDto toDto() => MediaKeyItemDto(
        type: MessageType.values.indexOf(type),
        ext: ext,
        aesKey: aesKey.toList(),
        iv: iv.toList(),
        mediaId: mediaId,
      );
}