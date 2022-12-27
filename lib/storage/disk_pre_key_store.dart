import 'dart:collection';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskPreKeyStore extends PreKeyStore {
  // singleton
  DiskPreKeyStore._();
  static final DiskPreKeyStore _instance = DiskPreKeyStore._();
  factory DiskPreKeyStore() {
    return _instance;
  }

  final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    // TODO: implement containsPreKey
    return store.containsKey(preKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    // TODO: implement loadPreKey
    if (!store.containsKey(preKeyId)) {
      throw InvalidKeyIdException('No such PreKeyRecord: $preKeyId');
    }
    return PreKeyRecord.fromBuffer(store[preKeyId]!);
    //throw UnimplementedError();
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    // TODO: implement removePreKey
    store.remove(preKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    // TODO: implement storePreKey
    store[preKeyId] = record.serialize();
    // throw UnimplementedError();
  }
}
