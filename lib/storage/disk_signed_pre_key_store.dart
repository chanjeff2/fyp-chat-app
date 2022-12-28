import 'dart:collection';
import 'dart:typed_data';

import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskSignedPreKeyStore extends SignedPreKeyStore {
  // singleton
  DiskSignedPreKeyStore._();
  static final DiskSignedPreKeyStore _instance = DiskSignedPreKeyStore._();
  factory DiskSignedPreKeyStore() {
    return _instance;
  }

  static const store = 'signedPreKey';
  // final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    var check = await DiskStorage().queryRow(store, signedPreKeyId);
    return check.isNotEmpty;
    // throw UnimplementedError();
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    var check = await DiskStorage().queryRow(store, signedPreKeyId);
    if (check.isEmpty) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord: $signedPreKeyId');
    }
    return SignedPreKeyRecord.fromSerialized(check[0]["signedPreKey"]);
    // throw UnimplementedError();
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final results = <SignedPreKeyRecord>[];
    final allKeys = await DiskStorage().queryAllRows(store);
    for (final serialized in allKeys) {
      results.add(SignedPreKeyRecord.fromSerialized(serialized["signedPreKey"]));
    }
    return results;
    // throw UnimplementedError();
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await DiskStorage().delete(store, signedPreKeyId);
    // throw UnimplementedError();
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    var signedPreKeyMap = {
      'id': signedPreKeyId,
      'preKey': record.serialize(),
    };
    var change = await DiskStorage().update(store, signedPreKeyMap);
    if (change == 0) await DiskStorage().insert(store, signedPreKeyMap);
    // throw UnimplementedError();
  }
}
