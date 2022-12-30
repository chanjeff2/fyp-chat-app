import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

/// store our and others identity keys
class DiskIdentityKeyStore extends IdentityKeyStore {
  // singleton
  DiskIdentityKeyStore._();
  static final DiskIdentityKeyStore _instance = DiskIdentityKeyStore._();
  factory DiskIdentityKeyStore(IdentityKeyPair keyPair, int regId) {
    keyPair = keyPair;
    regId = regId;
    return _instance;
  }

  // List of tables
  static const trustedKeysTab = "trustedKeys";
  static const identityKeyPairTab = "identityKeyPair";
  static const localRegistrationIdTab = "localRegistrationId";

  // Fields used in table
  static const id = "id";
  static const publicKey = "publicKey";
  static const privateKey = "privateKey";
  static const regId = "localRegistrationId";

  static const deviceId = "deviceId";
  static const deviceName = "deviceName";
  static const userPublicKey = "userPublicKey";

  late final IdentityKeyPair identityKeyPair;
  late final int localRegistrationId;

  // May need to call once outside
  Future<void> initTables() async {
    final Map<String, dynamic> mappedKeyPair = {
      id: 1,
      publicKey: identityKeyPair.getPublicKey().serialize(),
      privateKey: identityKeyPair.getPrivateKey().serialize(),
    };
    final Map<String, dynamic> mappedRegId = {
      id: 1,
      regId: localRegistrationId,
    };
    // Upsert the items to the table
    var changes = await DiskStorage().update(identityKeyPairTab, mappedKeyPair);
    if (changes == 0)
      await DiskStorage().insert(identityKeyPairTab, mappedKeyPair);
    changes = await DiskStorage().update(localRegistrationIdTab, mappedRegId);
    if (changes == 0)
      await DiskStorage().insert(localRegistrationIdTab, mappedRegId);
  }

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    var identity =
        await DiskStorage().queryRow(trustedKeysTab, address.getDeviceId());
    if (identity.isEmpty) return null;
    return IdentityKey(
        DjbECPublicKey(base64.decode(identity[0][userPublicKey])));
    // throw UnimplementedError();
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    return identityKeyPair;
    // throw UnimplementedError();
  }

  @override
  Future<int> getLocalRegistrationId() async {
    return localRegistrationId;
    // throw UnimplementedError();
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction) async {
    final identityOnCheck =
        await DiskStorage().queryRow(trustedKeysTab, address.getDeviceId());
    if (identityKey == null || identityOnCheck.isEmpty) {
      return false;
    }
    return const ListEquality().equals(
        base64.decode(identityOnCheck[0][userPublicKey]),
        identityKey.serialize());
    // throw UnimplementedError();
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    final identityOnCheck =
        await DiskStorage().queryRow(trustedKeysTab, address.getDeviceId());
    final existing = identityOnCheck[0][userPublicKey];
    if (identityKey == null) {
      return false;
    }
    if (identityKey.serialize() != existing) {
      final trustedKeyMap = {
        deviceId: address.getDeviceId(),
        deviceName: address.getName(),
        userPublicKey: base64.encode(identityKey.serialize()),
      };
      var change = await DiskStorage().update(trustedKeysTab, trustedKeyMap);
      if (change == 0)
        await DiskStorage().insert(trustedKeysTab, trustedKeyMap);
      return true;
    } else {
      return false;
    }
    // throw UnimplementedError();
  }
}
