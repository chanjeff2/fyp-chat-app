import 'package:fyp_chat_app/entities/user_entity.dart';
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
      where: '${UserEntity.columnUserId} = ?',
      whereArgs: [userId],
    );
    if (result.isEmpty) {
      return null;
    }
    final entity = UserEntity.fromJson(result[0]);
    return User.fromEntity(entity);
  }

  Future<User?> getContactByUsername(String username) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${UserEntity.columnUsername} = ?',
      whereArgs: [username],
    );
    if (result.isEmpty) {
      return null;
    }
    final entity = UserEntity.fromJson(result[0]);
    return User.fromEntity(entity);
  }

  Future<bool> removeContact(String userId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${UserEntity.columnUserId} = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<void> storeContact(User user) async {
    final userMap = user.toEntity().toJson();
    // try update
    final db = await DiskStorage().db;
    final count = await db.update(
      table,
      userMap,
      where: '${UserEntity.columnUserId} = ?',
      whereArgs: [user.userId],
    );
    // if no existing record, insert new record
    if (count == 0) await db.insert(table, userMap);
  }
}
