import 'package:flutter_test/flutter_test.dart';
import 'package:fyp_chat_app/dto/device_dto.dart';

void main() {
  late final DeviceDto deviceDto;
  setUpAll(() {
    //setup
    deviceDto = DeviceDto(
      id: "id",
      deviceId: 1,
      name: "name",
    );
  });
  test('serialize and deserialize to json', () async {
    //serialize
    final json = deviceDto.toJson();
    //de-serialize
    final receivedDeviceDto = DeviceDto.fromJson(json);
    //compare
    expect(receivedDeviceDto.id, deviceDto.id);
    expect(receivedDeviceDto.deviceId, deviceDto.deviceId);
    expect(receivedDeviceDto.name, deviceDto.name);
  });
}
