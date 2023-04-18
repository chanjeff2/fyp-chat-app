import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/media_item_entity.dart';

void main() {
  late final MediaItemEntity mediaItemEntity;
  setUpAll(() async {
    mediaItemEntity = MediaItemEntity(
      id: 'test',
      type: 0,
      content: [1, 2, 3],
      baseName: 'test.jpg',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = mediaItemEntity.toJson();
    //de-serialize
    final receivedMediaItemEntity = MediaItemEntity.fromJson(json);
    //compare
    expect(receivedMediaItemEntity.id, mediaItemEntity.id);
    expect(receivedMediaItemEntity.type, mediaItemEntity.type);
    expect(receivedMediaItemEntity.content, mediaItemEntity.content);
    expect(receivedMediaItemEntity.baseName, mediaItemEntity.baseName);
  });
}
