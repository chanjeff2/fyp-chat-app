import 'package:fyp_chat_app/models/user.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';

class ContactStore {
  // singleton
  ContactStore._();
  static final ContactStore _instance = ContactStore._();
  factory ContactStore() {
    return _instance;
  }

  static const table = 'contact';

  Future<User?> getContactById(String userId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${User.columnUserId} = ?',
      whereArgs: [userId],
    );
    if (result.isEmpty) {
      return null;
    }
    return User.fromJson(result[0]);
  }

  Future<User?> getContactByUsername(String username) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${User.columnUsername} = ?',
      whereArgs: [username],
    );
    if (result.isEmpty) {
      return null;
    }
    return User.fromJson(result[0]);
  }

  Future<bool> removeContact(String userId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${User.columnUserId} = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<void> storeContact(User user) async {
    final userMap = user.toJson();
    // try update
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      userMap,
      where: '${User.columnUserId} = ?',
      whereArgs: [user.userId],
    );
    // if no existing record, insert new record
    if (count == 0) await db.insert(table, userMap);
  }

  Future<List<User>?> getAllContact() async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
    );
    if (result.isEmpty) {
      return null;
    }
    List<User> userList = [];

    for (var i = 0; i < result.length; i++) {
      userList.add(User.fromJson(result[i]));
    }

    return userList;
  }
}
