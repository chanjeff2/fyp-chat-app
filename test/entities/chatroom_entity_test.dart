import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/chatroom_entity.dart';

void main() {
  late final ChatroomEntity chatroomEntity;
  setUpAll(() async {
    chatroomEntity = ChatroomEntity(
      id: 'test',
      type: 0,
      name: 'nameTest',
      createdAt: DateTime.now().toIso8601String(),
      groupType: 0,
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = chatroomEntity.toJson();
    //de-serialize
    final receivedChatroomEntity = ChatroomEntity.fromJson(json);
    //compare
    expect(receivedChatroomEntity.id, chatroomEntity.id);
    expect(receivedChatroomEntity.type, chatroomEntity.type);
    expect(receivedChatroomEntity.name, chatroomEntity.name);
    expect(receivedChatroomEntity.createdAt, chatroomEntity.createdAt);
    expect(receivedChatroomEntity.groupType, chatroomEntity.groupType);
  });
}
