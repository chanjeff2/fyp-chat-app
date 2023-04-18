import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/send_message_dao.dart';

void main() {
  late final SendMessageDao sendMessageDao;
  setUpAll(() async {
    //setup
    sendMessageDao = SendMessageDao(
      senderDeviceId: 1,
      recipientUserId: '1',
      chatroomId: '1',
      messageType: FCMEventType.textMessage,
      messages: [],
      sentAt: DateTime.now(),
    );
  });
  test('deserialize to dto', () async {
    //serialize
    final dto = sendMessageDao.toDto();
    //compare
    expect(dto.senderDeviceId, sendMessageDao.senderDeviceId);
    expect(dto.recipientUserId, sendMessageDao.recipientUserId);
    expect(dto.chatroomId, sendMessageDao.chatroomId);
    expect(dto.messageType, sendMessageDao.messageType);
    expect(dto.messages, sendMessageDao.messages);
    expect(dto.sentAt, sendMessageDao.sentAt.toIso8601String());
  });
}
