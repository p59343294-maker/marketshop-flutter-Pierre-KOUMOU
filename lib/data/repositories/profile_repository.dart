// lib/data/repositories/profile_repository.dart

import '../database_helper.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<UserProfile> get() async {
    final db = await _db.database;
    final maps = await db.query('user_profile', where: 'id = ?', whereArgs: [1]);
    if (maps.isEmpty) return UserProfile.defaultProfile;
    return UserProfile.fromMap(maps.first);
  }

  Future<void> save(UserProfile profile) async {
    final db = await _db.database;
    final existing = await db.query('user_profile', where: 'id = ?', whereArgs: [1]);
    if (existing.isEmpty) {
      await db.insert('user_profile', {'id': 1, ...profile.toMap()});
    } else {
      await db.update('user_profile', profile.toMap(), where: 'id = ?', whereArgs: [1]);
    }
  }

  Future<void> clear() async {
    final db = await _db.database;
    await db.delete('user_profile', where: 'id = ?', whereArgs: [1]);
  }
}
