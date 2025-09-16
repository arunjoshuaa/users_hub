import 'package:sqflite/sqflite.dart';
import 'package:users_hub/core/db/db_helper.dart';

import 'package:users_hub/features/profile/data/models/user_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveProfile(UserModel user);
  Future<UserModel?> getProfile();
   Future<void> deleteProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final DatabaseHelper _dbHelper;

  ProfileLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> saveProfile(UserModel user) async {
    final db = await _dbHelper.database;
    await db.insert(
      'profile',
      user.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

@override
Future<UserModel?> getProfile() async {
  final db = await _dbHelper.database;
  final maps = await db.query('profile', limit: 1); // fetch first row only
  if (maps.isNotEmpty) {
    return UserModel.fromDb(maps.first);
  }
  return null;
}
  @override
  Future<void> deleteProfile() async {
    final db = await _dbHelper.database;
    await db.delete('profile'); // 👈 clears table
  }
}
