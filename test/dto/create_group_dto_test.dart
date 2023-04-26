import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/create_group_dto.dart';

void main() {
  late final CreateGroupDto createGroupDto;
  setUpAll(() async {
    //setup
    createGroupDto = CreateGroupDto(
      name: "name",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = createGroupDto.toJson();
    //de-serialize
    final receivedCreateGroupDto = CreateGroupDto.fromJson(json);
    //compare
    expect(receivedCreateGroupDto.name, createGroupDto.name);
  });
}
