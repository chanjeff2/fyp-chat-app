import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/chat_message_entity.dart';

void main() {
  late final ChatMessageEntity chatMessageEntity;
  setUpAll(() async {
    chatMessageEntity = ChatMessageEntity(
      id: 1,
      senderUserId: '1',
      chatroomId: '2',
      content: 'test',
      type: 1,
      sentAt: DateTime.now().toIso8601String(),
      isRead: 0,
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = chatMessageEntity.toJson();
    //de-serialize
    final receivedChatMessageEntity = ChatMessageEntity.fromJson(json);
    //compare
    expect(receivedChatMessageEntity.id, chatMessageEntity.id);
    expect(
        receivedChatMessageEntity.senderUserId, chatMessageEntity.senderUserId);
    expect(receivedChatMessageEntity.chatroomId, chatMessageEntity.chatroomId);
    expect(receivedChatMessageEntity.content, chatMessageEntity.content);
    expect(receivedChatMessageEntity.type, chatMessageEntity.type);
    expect(receivedChatMessageEntity.sentAt, chatMessageEntity.sentAt);
    expect(receivedChatMessageEntity.isRead, chatMessageEntity.isRead);
  });
}
