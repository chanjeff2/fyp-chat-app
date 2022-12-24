import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class DiskIdentityKeyStore extends IdentityKeyStore {
  // singleton
  DiskIdentityKeyStore._();
  static final DiskIdentityKeyStore _instance = DiskIdentityKeyStore._();
  factory DiskIdentityKeyStore() {
    return _instance;
  }

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) {
    // TODO: implement getIdentity
    throw UnimplementedError();
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() {
    // TODO: implement getIdentityKeyPair
    throw UnimplementedError();
  }

  @override
  Future<int> getLocalRegistrationId() {
    // TODO: implement getLocalRegistrationId
    throw UnimplementedError();
  }

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
      IdentityKey? identityKey, Direction direction) {
    // TODO: implement isTrustedIdentity
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIdentity(
      SignalProtocolAddress address, IdentityKey? identityKey) {
    // TODO: implement saveIdentity
    throw UnimplementedError();
  }
}
