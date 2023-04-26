import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/media_item.dart';

void main() {
  late final MediaItem mediaItem;
  setUpAll(() async {
    //setup
    mediaItem = MediaItem(
      id: '1',
      content: Uint8List.fromList([1, 2, 3, 4, 5]),
      type: MessageType.image,
      baseName: 'test.jpg',
    );
  });
  test('serialilize and deserialize to entity', () async {
    //serialize
    final entity = mediaItem.toEntity();
    //de-seriailize
    final model = MediaItem.fromEntity(entity);
    //compare
    expect(model.id, mediaItem.id);
    expect(model.content, mediaItem.content);
    expect(model.type, mediaItem.type);
    expect(model.baseName, mediaItem.baseName);
  });
  test('file extension', () async {
    //compare
    expect(mediaItem.fileExtension, '.jpg');
  });
}
