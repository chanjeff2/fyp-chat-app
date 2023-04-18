import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/entities/session_entity.dart';

void main() {
  late final SessionEntity sessionEntity;
  setUpAll(() {
    sessionEntity = SessionEntity(1, 'testId', 'test');
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = sessionEntity.toJson();
    //de-serialize
    final receivedSessionEntity = SessionEntity.fromJson(json);
    //compare
    expect(receivedSessionEntity.deviceId, sessionEntity.deviceId);
    expect(receivedSessionEntity.userId, sessionEntity.userId);
    expect(receivedSessionEntity.session, sessionEntity.session);
  });
}
