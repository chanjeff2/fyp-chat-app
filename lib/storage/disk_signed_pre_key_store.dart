import 'dart:collection';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskSignedPreKeyStore extends SignedPreKeyStore {
  // singleton
  DiskSignedPreKeyStore._();
  static final DiskSignedPreKeyStore _instance = DiskSignedPreKeyStore._();
  factory DiskSignedPreKeyStore() {
    return _instance;
  }

  final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    return store.containsKey(signedPreKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    if (!store.containsKey(signedPreKeyId)) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord! $signedPreKeyId');
    }
    return SignedPreKeyRecord.fromSerialized(store[signedPreKeyId]!);
    // throw UnimplementedError();
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final results = <SignedPreKeyRecord>[];
    for (final serialized in store.values) {
      results.add(SignedPreKeyRecord.fromSerialized(serialized));
    }
    return results;
    // throw UnimplementedError();
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    store.remove(signedPreKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    store[signedPreKeyId] = record.serialize();
    // throw UnimplementedError();
  }
}
