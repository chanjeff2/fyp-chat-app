import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskPreKeyStore extends PreKeyStore {
  // singleton
  DiskPreKeyStore._();
  static final DiskPreKeyStore _instance = DiskPreKeyStore._();
  factory DiskPreKeyStore() {
    return _instance;
  }

  static const store = 'preKey';
  // final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    var check = await DiskStorage().queryRow(store, preKeyId);
    return check.isNotEmpty;
    // throw UnimplementedError();
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    var check = await DiskStorage().queryRow(store, preKeyId);
    if (check.isEmpty) {
      throw InvalidKeyIdException('No such PreKeyRecord: $preKeyId');
    }
    return PreKeyRecord.fromBuffer(check[0]["preKey"]);
    //throw UnimplementedError();
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    await DiskStorage().delete(store, preKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    var preKeyMap = {
      'id': preKeyId,
      'preKey': record.serialize(),
    };
    var change = await DiskStorage().update(store, preKeyMap);
      if (change == 0) await DiskStorage().insert(store, preKeyMap);
    // throw UnimplementedError();
  }
}
