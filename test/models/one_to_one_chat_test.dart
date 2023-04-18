import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/one_to_one_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';
import 'package:fyp_chat_app/models/user.dart';

void main() {
  late final OneToOneChat chat;
  setUpAll(() async {
    chat = OneToOneChat(
      target: User(
        userId: '1',
        username: 'test',
        displayName: 'displayTest',
        status: 'statusTest',
      ),
      latestMessage: PlainMessage(
        id: 1,
        content: 'test',
        senderUserId: '1',
        chatroomId: '1',
        isRead: false,
        sentAt: DateTime.now(),
      ),
      unread: 1,
      createdAt: DateTime.now(),
    );
  });
  test('serialize to entity', () async {
    final entity = chat.toEntity();
    expect(entity.id, chat.id);
    expect(entity.type, chat.type.index);
    expect(entity.createdAt, chat.createdAt.toIso8601String());
  });
}
