import 'package:flutter/foundation.dart';
import 'package:fyp_chat_app/dto/media_key_item_dto.dart';
import 'package:fyp_chat_app/models/chat_message.dart';

class MediaKeyItem {
  final MessageType type;
  final String baseName;
  final Uint8List aesKey;
  final Uint8List iv;
  final String mediaId;

  MediaKeyItem({
    required this.type,
    required this.baseName,
    required this.aesKey,
    required this.iv,
    required this.mediaId,
  });

  MediaKeyItem.fromDto(MediaKeyItemDto dto)
      : type = MessageType.values[dto.type],
        baseName = dto.baseName,
        aesKey = Uint8List.fromList(dto.aesKey),
        iv = Uint8List.fromList(dto.iv),
        mediaId = dto.mediaId;

  MediaKeyItemDto toDto() => MediaKeyItemDto(
        type: MessageType.values.indexOf(type),
        baseName: baseName,
        aesKey: aesKey.toList(),
        iv: iv.toList(),
        mediaId: mediaId,
      );
}