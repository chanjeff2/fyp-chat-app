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
    return store.containsKey(preKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    if (!store.containsKey(preKeyId)) {
      throw InvalidKeyIdException('No such PreKeyRecord: $preKeyId');
    }
    return PreKeyRecord.fromBuffer(store[preKeyId]!);
    //throw UnimplementedError();
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    store.remove(preKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    store[preKeyId] = record.serialize();
    // throw UnimplementedError();
  }
}
