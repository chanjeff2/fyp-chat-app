import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignalClient {
  SignalClient._();

  static final SignalClient _instance = SignalClient._();

  factory SignalClient() {
    return _instance;
  }

  late final int registrationId;
  late final IdentityKeyPair identityKeyPair;
  late final SignedPreKeyRecord signedPreKey;
  late final List<PreKeyRecord> preKeys;

  final sessionStore = InMemorySessionStore();
  final preKeyStore = InMemoryPreKeyStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();
  late final InMemoryIdentityKeyStore identityStore;

  Future<void> install() async {
    identityKeyPair = generateIdentityKeyPair();
    registrationId = generateRegistrationId(false);

    preKeys = generatePreKeys(0, 110);

    signedPreKey = generateSignedPreKey(identityKeyPair, 0);

    identityStore = InMemoryIdentityKeyStore(identityKeyPair, registrationId);

    for (var p in preKeys) {
      await preKeyStore.storePreKey(p.id, p);
    }
    await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);
  }

  Future<void> loadKeys() async {
    // TODO: load registrationId
    // TODO: load identityKeyPair
    // TODO: load signedPreKey
    // TODO: load preKeys

    identityStore = InMemoryIdentityKeyStore(identityKeyPair, registrationId);
  }
}
