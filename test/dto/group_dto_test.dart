import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/group_dto.dart';
import 'package:fyp_chat_app/models/enum.dart';
import 'package:fyp_chat_app/models/group_chat.dart';
import 'package:fyp_chat_app/models/plain_message.dart';

void main() {
  late final GroupDto groupDto;
  setUpAll(() async {
    //setup
    groupDto = GroupDto(
      id: "1",
      name: 'test',
      members: [],
      createdAt: DateTime.now().toIso8601String(),
      groupType: GroupType.Basic,
    );
  });
  test('serialilize and deserialize to json', () async {
    //seriailize
    final json = groupDto.toJson();
    //de-seriailize
    final model = GroupDto.fromJson(json);
    //compare
    expect(model.id, groupDto.id);
    expect(model.name, groupDto.name);
    expect(model.groupType, groupDto.groupType);
    expect(model.members.length, groupDto.members.length);
    expect(model.createdAt, groupDto.createdAt);
  });
}
