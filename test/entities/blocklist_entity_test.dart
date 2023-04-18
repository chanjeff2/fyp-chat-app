import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/blocklist_entity.dart';

void main() {
  late final BlocklistEntity blocklistEntity;
  setUpAll(() async {
    blocklistEntity = BlocklistEntity(
      block: 'test',
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = blocklistEntity.toJson();
    //de-serialize
    final receivedBlocklistEntity = BlocklistEntity.fromJson(json);
    //compare
    expect(receivedBlocklistEntity.block, blocklistEntity.block);
  });
}
