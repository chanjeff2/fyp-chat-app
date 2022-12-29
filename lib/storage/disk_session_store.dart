import 'dart:convert';

import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskSessionStore extends SessionStore {
  // singleton
  DiskSessionStore._();
  static final DiskSessionStore _instance = DiskSessionStore._();
  factory DiskSessionStore() {
    return _instance;
  }

  static const sessions = 'sessions';

  // Fields used in table
  static const deviceId = "deviceId";
  static const deviceName = "deviceName";
  static const sessionField = 'session';

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    var check = await DiskStorage().queryRow(sessions, address.getDeviceId());
    return check.isNotEmpty;
    // throw UnimplementedError();
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    await DiskStorage().deleteWithQuery(sessions, deviceName, name);
    // throw UnimplementedError();
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await DiskStorage().deleteByAddress(sessions, address.getDeviceId(), address.getName());
    // throw UnimplementedError();
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final deviceIds = <int>[];
    final keys = await DiskStorage().queryByDeviceName(sessions, name);
    for (final key in keys) {
      if (key[deviceId] != 1) {
        deviceIds.add(key[deviceId]);
      }
    }

    return deviceIds;
    // throw UnimplementedError();
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    try {
      var check = await DiskStorage().queryByAddress(sessions, address.getDeviceId(), address.getName());
      if (check.isNotEmpty) {
        return SessionRecord.fromSerialized(base64.decode(check[0][sessionField]));
      } else {
        return SessionRecord();
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
    // throw UnimplementedError();
  }

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    final sessionMap = {
        deviceId: address.getDeviceId(),
        deviceName: address.getName(),
        sessionField: base64.encode(record.serialize()),
    };
    var change = await DiskStorage().update(sessions, sessionMap);
    if (change == 0) await DiskStorage().insert(sessions, sessionMap);
    // throw UnimplementedError();
  }
}
