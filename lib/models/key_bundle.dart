import 'package:fyp_chat_app/extensions/signal_lib_extension.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../dto/key_bundle_dto.dart';
import 'device_key_bundle.dart';

class KeyBundle {
  final IdentityKey identityKey;
  final List<DeviceKeyBundle> deviceKeyBundles;

  KeyBundle({
    required this.identityKey,
    required this.deviceKeyBundles,
  });

  KeyBundle.fromDto(KeyBundleDto dto)
      : identityKey = IdentityKeyExtension.decodeFromString(dto.identityKey),
        deviceKeyBundles = dto.deviceKeyBundles
            .map((e) => DeviceKeyBundle.fromDto(e))
            .toList();
}
