import 'package:fyp_chat_app/signal/device_helper.dart';

import '../dto/create_device_dto.dart';
import '../dto/device_dto.dart';
import 'api.dart';

class DevicesApi extends Api {
  // singleton
  DevicesApi._();
  static final DevicesApi _instance = DevicesApi._();
  factory DevicesApi() {
    return _instance;
  }

  @override
  String pathPrefix = "/devices";

  Future<DeviceDto> addDevice(CreateDeviceDto dto) async {
    final json = await post("", body: dto.toJson(), useAuth: true);
    return DeviceDto.fromJson(json);
  }

  Future<DeviceDto> getDevice(int deviceId) async {
    final json = await get("/$deviceId", useAuth: true);
    return DeviceDto.fromJson(json);
  }

  Future<List<DeviceDto>> getAllDevices() async {
    final List<dynamic> json = await get("", useAuth: true);
    return json.map((device) => DeviceDto.fromJson(device)).toList();
  }

  Future<DeviceDto?> removeDevice({int? deviceId}) async {
    deviceId ??= await DeviceInfoHelper().getDeviceId();
    if (deviceId == null) {
      return null;
    }
    final json = await delete("/$deviceId", useAuth: true);
    return DeviceDto.fromJson(json);
  }
}
