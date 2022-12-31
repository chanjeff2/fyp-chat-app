import 'dart:convert';

import 'package:fyp_chat_app/dto/update_keys_dto.dart';
import 'package:fyp_chat_app/models/pre_key.dart';
import 'package:fyp_chat_app/models/signed_pre_key.dart';
import 'package:fyp_chat_app/network/devices_api.dart';
import 'package:fyp_chat_app/network/keys_api.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/disk_identity_key_store.dart';
import 'package:fyp_chat_app/storage/disk_pre_key_store.dart';
import 'package:fyp_chat_app/storage/disk_signed_pre_key_store.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignalClient {
  SignalClient._();

  static final SignalClient _instance = SignalClient._();

  factory SignalClient() {
    return _instance;
  }

  Future<void> initialize() async {
    await registerDevice();
    await generateAndStoreKeys();
  }

  Future<void> registerDevice() async {
    final dto = await DeviceInfoHelper().initDevice();
    final device = await DevicesApi().addDevice(dto);
    await DeviceInfoHelper().setDeviceId(device.deviceId);
  }

  Future<void> generateAndStoreKeys() async {
    // generate keys
    final identityKeyPair = generateIdentityKeyPair();
    final oneTimeKeys = generatePreKeys(0, 110);
    final signedPreKey = generateSignedPreKey(identityKeyPair, 0);

    // store keys
    await DiskIdentityKeyStore().storeIdentityKeyPair(identityKeyPair);
    for (var p in oneTimeKeys) {
      await DiskPreKeyStore().storePreKey(p.id, p);
    }
    await DiskSignedPreKeyStore()
        .storeSignedPreKey(signedPreKey.id, signedPreKey);

    // upload keys to Server
    final dto = UpdateKeysDto(
      (await DeviceInfoHelper().getDeviceId())!,
      identityKey: base64.encode(identityKeyPair.getPublicKey().serialize()),
      oneTimeKeys:
          oneTimeKeys.map((e) => PreKey.fromPreKeyRecord(e).toDto()).toList(),
      signedPreKey: SignedPreKey.fromSignedPreKeyRecord(signedPreKey).toDto(),
    );
    await KeysApi().updateKeys(dto);
  }
}
