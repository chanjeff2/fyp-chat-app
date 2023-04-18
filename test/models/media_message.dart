import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/media_item.dart';
import 'package:fyp_chat_app/models/media_message.dart';

void main() {
  late final MediaMessage mediaMessage;
  setUpAll(() async {
    //setup
    mediaMessage = MediaMessage(
      id: '1',
      senderUserId: '1',
      chatroomId: '1',
      sentAt: DateTime.now(),
      media: MediaItem(
        id: '1',
        type: MessageType.image,
        baseName: 'test.jpg',
        content: Uint8List.fromList([1, 2, 3, 4, 5]),
      ),
      type: MessageType.image,
      isRead: false,
    );
  });
  test('serialilize to entity', () async {
    //serialize
    final entity = mediaMessage.toEntity();
    //compare
    expect(entity.id, mediaMessage.id);
    expect(entity.senderUserId, mediaMessage.senderUserId);
    expect(entity.chatroomId, mediaMessage.chatroomId);
    expect(entity.content, mediaMessage.media.id);
    expect(entity.type, mediaMessage.messageType.index);
    expect(entity.sentAt, mediaMessage.sentAt.toIso8601String());
    expect(entity.isRead, mediaMessage.isRead ? 1 : 0);
  });
}
