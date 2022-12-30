import 'package:fyp_chat_app/models/signed_pre_key_pair.dart';
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

  static const store = 'signedPreKey';

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
    return SignedPreKeyPair.fromJson(check[0]).toSignedPreKeyRecord();
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final allKeys = await DiskStorage().queryAllRows(store);
    return allKeys
        .map((e) => SignedPreKeyPair.fromJson(e).toSignedPreKeyRecord())
        .toList();
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await DiskStorage().delete(store, signedPreKeyId);
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    final signedPreKeyMap =
        SignedPreKeyPair.fromSignedPreKeyRecord(record).toJson();
    var change = await DiskStorage().update(store, signedPreKeyMap);
    if (change == 0) await DiskStorage().insert(store, signedPreKeyMap);
  }
}
