import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';

// Class for accessing storage that handles all key store
class DiskStorage {
  // singleton
  DiskStorage._();
  static final DiskStorage _instance = DiskStorage._();
  factory DiskStorage() {
    return _instance;
  }

  static const databasePath = "USTalk.db";

  // Tables available
  // DiskIdentityKeyStore
  static const trustedKeys = "trustedKeys";
  static const identityKeyPair = "identityKeyPair";
  static const localRegistrationId = "localRegistrationId";

  // DiskPreKeyStore and DiskSignedPreKeyStore
  static const preKey = 'preKey';
  static const signedPreKey = 'signedPreKey';

  // DiskSessionStore
  static const sessions = 'sessions';

  // Field Storages
  static const columnId = 'id';
  static const deviceId = 'deviceId';
  static const deviceName = 'deviceName';
  static const userPublicKey = 'userPublicKey';
  static const publicKey = 'publicKey';
  static const privateKey = 'privateKey';
  static const regId = 'localRegistrationId';
  static const preKeyField = 'preKey';
  static const signedPreKeyField = 'signedPreKey';
  static const sessionField = 'session';

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
     return await openDatabase(
       join(await getDatabasesPath(), databasePath),
       password: "password", // TODO: Find a way to make a secure password and save it in SecureStorage
       onCreate: (db, version) {
          db.execute(
           "CREATE TABLE $trustedKeys($deviceId INTEGER, $deviceName STRING, $userPublicKey STRING, PRIMARY KEY ($deviceId, $deviceName));",
          );
          db.execute(
           "CREATE TABLE $identityKeyPair($columnId INTEGER PRIMARY KEY, $publicKey STRING, $privateKey STRING);",
          );
          db.execute(
           "CREATE TABLE $localRegistrationId($columnId INTEGER PRIMARY KEY, $regId INTEGER);",
          );
          db.execute(
           "CREATE TABLE $preKey($columnId INTEGER PRIMARY KEY, $preKeyField STRING);",
          );
          db.execute(
           "CREATE TABLE $signedPreKey($columnId INTEGER PRIMARY KEY, $signedPreKeyField STRING);",
          );
          db.execute(
           "CREATE TABLE $sessions($deviceId INTEGER, $deviceName STRING, $sessionField STRING, PRIMARY KEY ($deviceId, $deviceName));",
          );
       },
     );
  }

  // Inserting to table
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await _instance.database;
    return await db.insert(table, row);
  }

  // Get all rows of the table
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await _instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRow(String table, int id) async {
    Database db = await _instance.database;
    return await db.query(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryByDeviceName(String table, String name) async {
    Database db = await _instance.database;
    return await db.query(table, where: 'deviceName = ?', whereArgs: [name]);
  }

  Future<List<Map<String, dynamic>>> queryByAddress(String table, int id, String name) async {
    Database db = await _instance.database;
    return await db.query(table, where: 'id = ? AND deviceName = ?', whereArgs: [id, name]);
  }

  // Update a table instance
  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await _instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database db = await _instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteWithQuery(String table, String field, String args) async {
    Database db = await _instance.database;
    return await db.delete(table, where: '$field = ?', whereArgs: [args]);
  }
  
  Future<int> deleteByAddress(String table, int id, String name) async {
    Database db = await _instance.database;
    return await db.delete(table, where: 'id = ? AND deviceName = ?', whereArgs: [id, name]);
  }
}