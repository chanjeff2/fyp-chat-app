import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/update_group_dto.dart';
import 'package:fyp_chat_app/dto/update_user_dto.dart';

void main() {
  late final UpdateGroupDto updateGroupDto1;
  late final UpdateGroupDto updateGroupDto2;
  late final Map<String, dynamic> updateGroupDtoJson;
  setUpAll(() async {
    //setup
    updateGroupDto1 = UpdateGroupDto(
      name: "Dragon's Back Hikers",
    );

    updateGroupDto2 = UpdateGroupDto(
      description: "This is the description of the group",
    );

    updateGroupDtoJson = {
      "_id": "3e33f47a59ad4b81bc46e444",
      "groupType": "basic",
      "isPublic": true,
      "name": "Team Rocket",
      "description": "We catch Pokemons",
      "profilePicUrl":
          "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything",
      "createdAt": "2023-04-06T14:11:42.820Z",
      "updatedAt": "2023-04-15T12:35:04.345Z"
    };
  });
  test('serialize and deserialize to json, group name only', () async {
    //serialize
    final json = updateGroupDto1.toJson();
    //de-serialize
    final receivedUpdateGroupDto = UpdateGroupDto.fromJson(json);
    //compare
    expect(receivedUpdateGroupDto.name, updateGroupDto1.name);
    expect(receivedUpdateGroupDto.description, null);
    expect(receivedUpdateGroupDto.profilePicUrl, null);
    expect(receivedUpdateGroupDto.createdAt, null);
    expect(receivedUpdateGroupDto.updatedAt, null);
    expect(receivedUpdateGroupDto.isPublic, null);
  });

  test('serialize and deserialize to json, status only', () async {
    //serialize
    final json = updateGroupDto2.toJson();
    //de-serialize
    final receivedUpdateGroupDto = UpdateGroupDto.fromJson(json);
    //compare
    expect(receivedUpdateGroupDto.name, null);
    expect(receivedUpdateGroupDto.description, updateGroupDto2.description);
    expect(receivedUpdateGroupDto.profilePicUrl, null);
    expect(receivedUpdateGroupDto.createdAt, null);
    expect(receivedUpdateGroupDto.updatedAt, null);
    expect(receivedUpdateGroupDto.isPublic, null);
  });

  test('deserialize from json, with all group info', () async {
    //de-serialize
    final receivedUpdateGroupDto = UpdateGroupDto.fromJson(updateGroupDtoJson);
    //compare
    expect(receivedUpdateGroupDto.name, "Team Rocket");
    expect(receivedUpdateGroupDto.description, "We catch Pokemons");
    expect(receivedUpdateGroupDto.profilePicUrl,
        "https://storage.googleapis.com/download/storage/test-link-doesnt-link-to-anything");
    expect(receivedUpdateGroupDto.createdAt, "2023-04-06T14:11:42.820Z");
    expect(receivedUpdateGroupDto.updatedAt, "2023-04-15T12:35:04.345Z");
    expect(receivedUpdateGroupDto.isPublic, true);
  });
}
