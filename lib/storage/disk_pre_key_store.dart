import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskPreKeyStore extends PreKeyStore {
  // singleton
  DiskPreKeyStore._();
  static final DiskPreKeyStore _instance = DiskPreKeyStore._();
  factory DiskPreKeyStore() {
    return _instance;
  }

  @override
  Future<bool> containsPreKey(int preKeyId) {
    // TODO: implement containsPreKey
    throw UnimplementedError();
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) {
    // TODO: implement loadPreKey
    throw UnimplementedError();
  }

  @override
  Future<void> removePreKey(int preKeyId) {
    // TODO: implement removePreKey
    throw UnimplementedError();
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) {
    // TODO: implement storePreKey
    throw UnimplementedError();
  }
}
