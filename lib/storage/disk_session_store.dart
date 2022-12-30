import 'package:fyp_chat_app/models/session.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskSessionStore extends SessionStore {
  // singleton
  DiskSessionStore._();
  static final DiskSessionStore _instance = DiskSessionStore._();
  factory DiskSessionStore() {
    return _instance;
  }

  static const table = 'sessions';

  // Fields used in table
  static const deviceId = "deviceId";
  static const deviceName = "deviceName";
  static const sessionField = 'session';

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${Session.columnName} = ? AND ${Session.columnDeviceId} = ?',
      whereArgs: [address.getName(), address.getDeviceId()],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    final db = await DiskStorage().db;
    await db.delete(
      table,
      where: '${Session.columnName} = ?',
      whereArgs: [name],
    );
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    final db = await DiskStorage().db;
    await db.delete(
      table,
      where: '${Session.columnName} = ? AND ${Session.columnDeviceId} = ?',
      whereArgs: [address.getName(), address.getDeviceId()],
    );
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${Session.columnName} = ?',
      whereArgs: [name],
    );
    final deviceIds = result
        .map((e) => Session.fromJson(e).deviceId)
        .where((deviceId) => deviceId != 1)
        .toList();
    return deviceIds;
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    final db = await DiskStorage().db;
    try {
      final result = await db.query(
        table,
        where: '${Session.columnName} = ? AND ${Session.columnDeviceId} = ?',
        whereArgs: [address.getName(), address.getDeviceId()],
      );
      if (result.isNotEmpty) {
        return Session.fromJson(result[0]).toSessionRecord();
      } else {
        return SessionRecord();
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    final sessionMap = Session.fromSessionRecord(
      name: address.getName(),
      deviceId: address.getDeviceId(),
      record: record,
    ).toJson();
    // try update
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      sessionMap,
      where: '${Session.columnName} = ? AND ${Session.columnDeviceId} = ?',
      whereArgs: [address.getName(), address.getDeviceId()],
    );
    // if no existing record, insert new record
    if (count == 0) await db.insert(table, sessionMap);
  }
}
