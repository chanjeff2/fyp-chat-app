import 'package:fyp_chat_app/models/pre_key_pair.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

/// store only our pre keys/one time keys
class DiskPreKeyStore extends PreKeyStore {
  // singleton
  DiskPreKeyStore._();
  static final DiskPreKeyStore _instance = DiskPreKeyStore._();
  factory DiskPreKeyStore() {
    return _instance;
  }

  static const table = 'preKey';

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${PreKeyPair.columnId} = ?',
      whereArgs: [preKeyId],
    );
    return result.isNotEmpty;
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${PreKeyPair.columnId} = ?',
      whereArgs: [preKeyId],
    );
    if (result.isEmpty) {
      throw InvalidKeyIdException('No such PreKeyRecord: $preKeyId');
    }
    return PreKeyPair.fromJson(result[0]).toPreKeyRecord();
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    final db = await DiskStorage().db;
    await db.delete(
      table,
      where: '${PreKeyPair.columnId} = ?',
      whereArgs: [preKeyId],
    );
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    final preKeyMap = PreKeyPair.fromPreKeyRecord(record).toJson();
    // try update
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      preKeyMap,
      where: '${PreKeyPair.columnId} = ?',
      whereArgs: [preKeyId],
    );
    // if no existing record, insert new record
    if (count == 0) await db.insert(table, preKeyMap);
  }
}
