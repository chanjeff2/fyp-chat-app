import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fyp_chat_app/models/their_identity_key.dart';
import 'package:fyp_chat_app/signal/device_helper.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:fyp_chat_app/storage/secure_storage.dart';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// store our and others identity keys
class DiskIdentityKeyStore extends IdentityKeyStore {
  // singleton
  DiskIdentityKeyStore._();
  static final DiskIdentityKeyStore _instance = DiskIdentityKeyStore._();
  factory DiskIdentityKeyStore() {
    return _instance;
  }

  // List of tables
  static const table = "identityKey";

  static const identityKeyPairKey = "identityKeyPair";

  Future<void> storeIdentityKeyPair(IdentityKeyPair identityKeyPair) async {
    await SecureStorage().write(
      key: identityKeyPairKey,
      value: base64.encode(identityKeyPair.serialize()),
    );
  }

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where:
          '${TheirIdentityKey.columnUserId} = ? AND ${TheirIdentityKey.columnDeviceId} = ?',
      whereArgs: [address.getName(), address.getDeviceId()],
    );
    if (result.isEmpty) return null;
    return TheirIdentityKey.fromJson(result[0]).toIdentityKey();
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    final result = await SecureStorage().read(key: identityKeyPairKey);
    final serialized = base64.decode(result!);
    return IdentityKeyPair.fromSerialized(serialized);
  }

  @override
  Future<int> getLocalRegistrationId() async {
    final prefs = await SharedPreferences.getInstance();
    final registrationId =
        await prefs.getInt(DeviceInfoHelper.registrationIdKey);
    return registrationId!;
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction) async {
    return true; // allow all in-coming and out-going message
    // shortcut if identityKey is null
    if (identityKey == null) {
      return false;
    }
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where:
          '${TheirIdentityKey.columnUserId} = ? AND ${TheirIdentityKey.columnDeviceId} = ?',
      whereArgs: [address.getName(), address.getDeviceId()],
    );
    if (result.isEmpty) {
      return false;
    }
    final identityKeyOnDisk =
        TheirIdentityKey.fromJson(result[0]).toIdentityKey();
    return const ListEquality().equals(
      identityKeyOnDisk.serialize(),
      identityKey.serialize(),
    );
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) async {
    if (identityKey == null) {
      return false;
    }

    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where:
          '${TheirIdentityKey.columnUserId} = ? AND ${TheirIdentityKey.columnDeviceId} = ?',
      whereArgs: [address.getName(), address.getDeviceId()],
    );
    if (result.isEmpty) {
      return false;
    }

    final identityKeyOnDisk =
        TheirIdentityKey.fromJson(result[0]).toIdentityKey();

    final isEqual = const ListEquality().equals(
      identityKeyOnDisk.serialize(),
      identityKey.serialize(),
    );

    if (isEqual) {
      return false;
    } else {
      final identityKeyMap = TheirIdentityKey.fromIdentityKey(
        deviceId: address.getDeviceId(),
        userId: address.getName(),
        key: identityKey,
      ).toJson();
      // try update
      final count = await db.update(
        table,
        identityKeyMap,
        where:
            '${TheirIdentityKey.columnUserId} = ? AND ${TheirIdentityKey.columnDeviceId} = ?',
        whereArgs: [address.getName(), address.getDeviceId()],
      );
      // if no existing record, insert new record
      if (count == 0) await db.insert(table, identityKeyMap);
      return true;
    }
  }
}
