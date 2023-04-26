import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/models/media_key_item.dart';

void main() {
  late final MediaKeyItem mediaKeyItem;
  setUpAll(() async {
    //setup
    mediaKeyItem = MediaKeyItem(
      type: MessageType.image,
      baseName: 'test.jpg',
      aesKey: Uint8List.fromList([1, 2, 3, 4, 5]),
      iv: Uint8List.fromList([6, 7, 8, 9, 10]),
      mediaId: '1',
    );
  });
  test('serialilize and deserialize to dto', () async {
    //serialize
    final dto = mediaKeyItem.toDto();
    //de-seriailize
    final model = MediaKeyItem.fromDto(dto);
    //compare
    expect(model.type, mediaKeyItem.type);
    expect(model.baseName, mediaKeyItem.baseName);
    expect(model.aesKey, mediaKeyItem.aesKey);
    expect(model.iv, mediaKeyItem.iv);
    expect(model.mediaId, mediaKeyItem.mediaId);
  });
}
