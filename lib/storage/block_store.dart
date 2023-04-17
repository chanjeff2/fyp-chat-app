import 'dart:convert';

import 'package:fyp_chat_app/entities/blocklist_entity.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';

class BlockStore {
  // singleton
  BlockStore._();
  static final BlockStore _instance = BlockStore._();
  factory BlockStore() {
    return _instance;
  }

  static const table = 'block';

  Future<bool> contain(String chatroomId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${BlocklistEntity.columnBlock} = ?',
      whereArgs: [chatroomId],
    );
    if (result.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> storeBlockedByBlockList(List<String> blocklist) async {
    final db = await DiskStorage().db;

    for (var element in (blocklist)) {
      await db.insert(
        table,
        BlocklistEntity(
          block: element,
        ).toJson(),
      );
    }
  }

  Future<void> storeBlocked(String chatroomId) async {
    final db = await DiskStorage().db;
    await db.insert(
      table,
      BlocklistEntity(
        block: chatroomId,
      ).toJson(),
    );
  }

  Future<void> removeBlocked(String chatroomId) async {
    final db = await DiskStorage().db;
    await db.delete(
      table,
      where: '${BlocklistEntity.columnBlock} = ?',
      whereArgs: [chatroomId],
    );
  }
}
