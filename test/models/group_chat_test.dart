import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';

void main() {
  late final GroupChat groupChat;
  late final GroupDto groupDto;
  setUpAll(() async {
    //setup
    groupChat = GroupChat(
      id: "1",
      name: 'test',
      members: [],
      createdAt: DateTime.now(),
      groupType: GroupType.Basic,
      unread: 0,
      latestMessage: PlainMessage(
        id: 1,
        chatroomId: "1",
        senderUserId: "2",
        sentAt: DateTime.now(),
        content: "gg",
        isRead: false,
      ),
    );
    groupDto = GroupDto(
      id: "1",
      name: 'test',
      members: [],
      createdAt: DateTime.now().toIso8601String(),
      groupType: GroupType.Basic,
    );
  });
  test('serialize to entity', () async {
    //seriailize
    final entity = groupChat.toEntity();
    //compare
    expect(entity.id, groupChat.id);
    expect(entity.name, groupChat.name);
    expect(entity.type, groupChat.type.index);
    expect(entity.createdAt, groupChat.createdAt.toIso8601String());
    expect(entity.groupType, groupChat.groupType.index);
  });
  test('de-serialize from DTO', () async {
    //de-seriailize
    final model = GroupChat.fromDto(groupDto);
    //compare
    expect(model.id, groupDto.id);
    expect(model.name, groupDto.name);
    expect(model.groupType, groupDto.groupType);
    expect(model.members.length, groupDto.members.length);
  });
}
