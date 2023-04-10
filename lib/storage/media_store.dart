import 'package:fyp_chat_app/entities/media_item_entity.dart';
import 'package:fyp_chat_app/models/media_item.dart';
import 'package:fyp_chat_app/storage/disk_storage.dart';
import 'package:sqflite/sqflite.dart';

class MediaStore {
  // singleton
  MediaStore._();
  static final MediaStore _instance = MediaStore._();
  factory MediaStore() {
    return _instance;
  }

  static const table = 'media';
  
  Future<MediaItem> getMediaById(String mediaId) async {
    final db = await DiskStorage().db;
    final result = await db.query(
      table,
      where: '${MediaItemEntity.columnId} = ?',
      whereArgs: [mediaId],
    );
    final media = MediaItemEntity.fromJson(result[0]); 
    return MediaItem.fromEntity(media);
  }

  Future<bool> removeMedia(String mediaId) async {
    final db = await DiskStorage().db;
    final count = await db.delete(
      table,
      where: '${MediaItemEntity.columnId} = ?',
      whereArgs: [mediaId],
    );
    return count > 0;
  }

  Future<int> storeMedia(MediaItem media) async {
    final mediaMap = media.toEntity().toJson();
    final db = await DiskStorage().db;
    final id = await db.insert(table, mediaMap);
    return id;
  }
}