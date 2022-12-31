import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/create_device_dto.dart';

class DeviceInfoHelper {
  // singleton
  DeviceInfoHelper._();
  static final DeviceInfoHelper _instance = DeviceInfoHelper._();
  factory DeviceInfoHelper() {
    return _instance;
  }

  static const deviceIdKey = 'device_id';
  static const deviceNameKey = 'device_Name';
  static const registrationIdKey = 'registration_id';

  // should only be called once in app life time (during register/login)
  Future<CreateDeviceDto> initDevice() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      throw Exception(
          "cannot retrieve Firebase Cloud Messaging Token to add Device");
    }

    final registrationId = generateRegistrationId(false);
    final deviceName = "later use library to get";

    // store registrationId and DeviceName
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(registrationIdKey, registrationId);
    await prefs.setString(deviceNameKey, deviceName);

    return CreateDeviceDto(
      registrationId: registrationId,
      name: deviceName,
      firebaseMessagingToken: fcmToken,
    );
  }

  Future<void> setDeviceId(int deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(deviceIdKey, deviceId);
  }

  Future<int?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(deviceIdKey);
    return id;
  }
}
