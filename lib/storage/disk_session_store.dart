import 'dart:collection';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskSessionStore extends SessionStore {
  // singleton
  DiskSessionStore._();
  static final DiskSessionStore _instance = DiskSessionStore._();
  factory DiskSessionStore() {
    return _instance;
  }

  HashMap<SignalProtocolAddress, Uint8List> sessions = HashMap<SignalProtocolAddress, Uint8List>();

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    return sessions.containsKey(address);
    // throw UnimplementedError();
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    for (final k in sessions.keys.toList()) {
      if (k.getName() == name) {
        sessions.remove(k);
      }
    }
    // throw UnimplementedError();
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    sessions.remove(address);
    // throw UnimplementedError();
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final deviceIds = <int>[];

    for (final key in sessions.keys) {
      if (key.getName() == name && key.getDeviceId() != 1) {
        deviceIds.add(key.getDeviceId());
      }
    }

    return deviceIds;
    // throw UnimplementedError();
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    try {
      if (await containsSession(address)) {
        return SessionRecord.fromSerialized(sessions[address]!);
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
    sessions[address] = record.serialize();
    // throw UnimplementedError();
  }
}
