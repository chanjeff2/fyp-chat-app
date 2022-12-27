import 'package:fyp_chat_app/storage/secure_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../dto/create_device_dto.dart';

class DeviceInfoHelper {
  // singleton
  DeviceInfoHelper._();
  static final DeviceInfoHelper _instance = DeviceInfoHelper._();
  factory DeviceInfoHelper() {
    return _instance;
  }

  // should only be called once in app life time (during register/login)
  Future<CreateDeviceDto> initDevice() async {
    final registrationId = generateRegistrationId(false);
    final name = "later use library to get";
    return CreateDeviceDto(registrationId: registrationId, name: name);
  }

  Future<void> setDeviceId(int deviceId) async {
    // TODO: implement setDeviceId
    await SecureStorage().write(key: "deviceId", value: deviceId.toString());
    // throw UnimplementedError();
  }

  Future<int> getDeviceId() async {
    // TODO: implement getDeviceId
    var id = await SecureStorage().read(key: "deviceId");
    if (id != null) {
      return int.parse(id);
    }
    return 1; // or throw error?
  }
}
