import 'package:fyp_chat_app/entities/signed_pre_key_pair_entity.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

/// store only our signed pre keys
class DiskSignedPreKeyStore extends SignedPreKeyStore {
  // singleton
  DiskSignedPreKeyStore._();
  static final DiskSignedPreKeyStore _instance = DiskSignedPreKeyStore._();
  factory DiskSignedPreKeyStore() {
    return _instance;
  }

  static const table = 'signedPreKey';

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${SignedPreKeyPairEntity.columnId} = ?',
      whereArgs: [signedPreKeyId],
    );
    return result.isNotEmpty;
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${SignedPreKeyPairEntity.columnId} = ?',
      whereArgs: [signedPreKeyId],
    );
    if (result.isEmpty) {
      throw InvalidKeyIdException(
          'No such SignedPreKeyRecord: $signedPreKeyId');
    }
    return SignedPreKeyPairEntity.fromJson(result[0]).toSignedPreKeyRecord();
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final db = await DiskStorage().db;
    final allKeys = await db.query(table);
    return allKeys
        .map((e) => SignedPreKeyPairEntity.fromJson(e).toSignedPreKeyRecord())
        .toList();
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    final db = await DiskStorage().db;
    await db.delete(
      table,
      where: '${SignedPreKeyPairEntity.columnId} = ?',
      whereArgs: [signedPreKeyId],
    );
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    final signedPreKeyMap =
        SignedPreKeyPairEntity.fromSignedPreKeyRecord(record).toJson();
    // try update
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      signedPreKeyMap,
      where: '${SignedPreKeyPairEntity.columnId} = ?',
      whereArgs: [signedPreKeyId],
    );
    // if no existing record, insert new record
    if (count == 0) await db.insert(table, signedPreKeyMap);
  }
}
