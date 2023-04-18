import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/create_device_dto.dart';

void main() {
  late final CreateDeviceDto createDeviceDto;
  setUpAll(() async {
    //setup
    createDeviceDto = CreateDeviceDto(
      registrationId: 1,
      name: "name",
      firebaseMessagingToken: "firebaseMessagingToken",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = createDeviceDto.toJson();
    //de-serialize
    final receivedCreateDeviceDto = CreateDeviceDto.fromJson(json);
    //compare
    expect(
        receivedCreateDeviceDto.registrationId, createDeviceDto.registrationId);
    expect(receivedCreateDeviceDto.name, createDeviceDto.name);
    expect(receivedCreateDeviceDto.firebaseMessagingToken,
        createDeviceDto.firebaseMessagingToken);
  });
}
