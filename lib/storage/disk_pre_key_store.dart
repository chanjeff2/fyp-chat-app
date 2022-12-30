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

  static const store = 'preKey';

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    var check = await DiskStorage().queryRow(store, preKeyId);
    return check.isNotEmpty;
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    var check = await DiskStorage().queryRow(store, preKeyId);
    if (check.isEmpty) {
      throw InvalidKeyIdException('No such PreKeyRecord: $preKeyId');
    }
    return PreKeyPair.fromJson(check[0]).toPreKeyRecord();
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    await DiskStorage().delete(store, preKeyId);
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    final preKeyMap = PreKeyPair.fromPreKeyRecord(record).toJson();
    var change = await DiskStorage().update(store, preKeyMap);
    if (change == 0) await DiskStorage().insert(store, preKeyMap);
  }
}
