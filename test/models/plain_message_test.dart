import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/plain_message.dart';

void main() {
  late final PlainMessage plainMessage;
  setUpAll(() async {
    plainMessage = PlainMessage(
      id: 1,
      content: 'test',
      senderUserId: '1',
      chatroomId: '1',
      isRead: false,
      sentAt: DateTime.now(),
    );
  });
  test('serialize to entity', () async {
    final entity = plainMessage.toEntity();
    expect(entity.id, plainMessage.id);
    expect(entity.senderUserId, plainMessage.senderUserId);
    expect(entity.chatroomId, plainMessage.chatroomId);
    expect(entity.content, plainMessage.content);
    expect(entity.sentAt, plainMessage.sentAt.toIso8601String());
    expect(entity.isRead, plainMessage.isRead ? 1 : 0);
  });
}
