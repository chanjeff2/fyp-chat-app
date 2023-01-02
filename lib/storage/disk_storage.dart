import 'package:fyp_chat_app/models/pre_key_pair.dart';
import 'package:fyp_chat_app/models/session.dart';
import 'package:fyp_chat_app/models/signed_pre_key_pair.dart';
import 'package:fyp_chat_app/models/their_identity_key.dart';
import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/storage/contact_store.dart';
import 'package:fyp_chat_app/storage/disk_identity_key_store.dart';
import 'package:fyp_chat_app/storage/disk_pre_key_store.dart';
import 'package:fyp_chat_app/storage/disk_session_store.dart';
import 'package:fyp_chat_app/storage/disk_signed_pre_key_store.dart';
import 'package:fyp_chat_app/storage/secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'dart:convert';

// Class for accessing storage that handles all key store
class DiskStorage {
  // singleton
  DiskStorage._();
  static final DiskStorage _instance = DiskStorage._();
  factory DiskStorage() {
    return _instance;
  }

  static const databasePath = "USTalk.db";

  static const databasePasswordKey = "databasePasswordKey";

  static Database? _database;

  Future<Database> get db async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final password = await getDatabasePassword();
    return await openDatabase(
      join(await getDatabasesPath(), databasePath),
      password: password,
      version: 7,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE ${DiskIdentityKeyStore.table}(${TheirIdentityKey.createTableCommandFields});",
        );
        db.execute(
          "CREATE TABLE ${DiskPreKeyStore.table}(${PreKeyPair.createTableCommandFields});",
        );
        db.execute(
          "CREATE TABLE ${DiskSignedPreKeyStore.table}(${SignedPreKeyPair.createTableCommandFields});",
        );
        db.execute(
          "CREATE TABLE ${DiskSessionStore.table}(${Session.createTableCommandFields});",
        );
        db.execute(
          "CREATE TABLE ${ContactStore.table}(${User.createTableCommandFields});",
        );
      },
    );
  }

  Future<String> getDatabasePassword() async {
    var password = await SecureStorage().read(key: databasePasswordKey);
    if (password == null) {
      password = generateDatabasePassword();
      SecureStorage().write(key: databasePasswordKey, value: password);
    }
    return password;
  }

  String generateDatabasePassword() {
    var random = Random.secure();
    // generate random int with 32 digits, 256 is the max value,
    // used in generating random password for the database in base64 encoding
    var values = List<int>.generate(
      32,
      (i) => random.nextInt(255),
    );
    return base64UrlEncode(values);
  }
}
