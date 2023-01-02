import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';

import '../dto/device_key_bundle_dto.dart';

class DeviceKeyBundle {
  int deviceId;
  int registrationId;
  SignedPreKey signedPreKey;
  PreKey? oneTimeKey;

  DeviceKeyBundle({
    required this.deviceId,
    required this.registrationId,
    required this.signedPreKey,
    this.oneTimeKey,
  });

  DeviceKeyBundle.fromDto(DeviceKeyBundleDto dto)
      : deviceId = dto.deviceId,
        registrationId = dto.registrationId,
        signedPreKey = SignedPreKey.fromDto(dto.signedPreKey),
        oneTimeKey =
            dto.oneTimeKey == null ? null : PreKey.fromDto(dto.oneTimeKey!);
}
