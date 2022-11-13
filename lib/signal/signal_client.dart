import 'package:fyp_chat_app/models/signal_keys_db.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    registrationId = generateRegistrationId(false);
    identityKeyPair = generateIdentityKeyPair();
    signedPreKey = generateSignedPreKey(identityKeyPair, 0);
    preKeys = generatePreKeys(0, 110);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("registrationId", registrationId);
    await prefs.setString("identityKeyPair",
        IdentityKeyPairDb.fromIdentityKeyPair(identityKeyPair).buffer);
    await prefs.setString("signedPreKey",
        SignedPreKeyRecordDb.fromSignedPreKeyRecord(signedPreKey).buffer);
    await prefs.setStringList("preKeys",
        preKeys.map((e) => PreKeyRecordDb.fromPreKeyRecord(e).buffer).toList());

    identityStore = InMemoryIdentityKeyStore(identityKeyPair, registrationId);

    for (var p in preKeys) {
      await preKeyStore.storePreKey(p.id, p);
    }
    await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);
  }

  Future<void> loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    registrationId = prefs.getInt("registrationId")!;
    identityKeyPair = IdentityKeyPairDb(prefs.getString("identityKeyPair")!)
        .toIdentityKeyPair();
    signedPreKey =
        SignedPreKeyRecordDb(prefs.getString("signedPreKey")!).toPreKeyRecord();
    preKeys = prefs
        .getStringList("preKeys")!
        .map((e) => PreKeyRecordDb(e).toPreKeyRecord())
        .toList();

    identityStore = InMemoryIdentityKeyStore(identityKeyPair, registrationId);

    for (var p in preKeys) {
      await preKeyStore.storePreKey(p.id, p);
    }
    await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);
  }
}
