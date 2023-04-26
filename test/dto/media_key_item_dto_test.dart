import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/chat_message.dart';
import 'package:fyp_chat_app/dto/media_key_item_dto.dart';

void main() {
  late final MediaKeyItemDto mediaKeyItemDto;
  setUpAll(() async {
    //setup
    mediaKeyItemDto = MediaKeyItemDto(
      type: 'image',
      baseName: 'test.jpg',
      aesKey: [1, 2, 3, 4, 5],
      iv: [6, 7, 8, 9, 10],
      mediaId: '1',
    );
  });
  test('serialilize and deserialize to json', () async {
    //serialize
    final json = mediaKeyItemDto.toJson();
    //de-seriailize
    final model = MediaKeyItemDto.fromJson(json);
    //compare
    expect(model.type, mediaKeyItemDto.type);
    expect(model.baseName, mediaKeyItemDto.baseName);
    expect(model.aesKey, mediaKeyItemDto.aesKey);
    expect(model.iv, mediaKeyItemDto.iv);
    expect(model.mediaId, mediaKeyItemDto.mediaId);
  });
}
