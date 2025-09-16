import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:users_hub/core/db/db_helper.dart';
import 'package:users_hub/features/profile/domain/entities/user.dart';
import 'package:users_hub/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:users_hub/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:users_hub/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dbHelper = DatabaseHelper.instance;
  final localDataSource = ProfileLocalDataSourceImpl(dbHelper);
  return ProfileRepositoryImpl(localDataSource);
});

final saveProfileProvider = FutureProvider.family<void, User>((ref, user) async {
  final repository = ref.watch(profileRepositoryProvider);
  await repository.saveProfile(user);
});

final getProfileProvider = FutureProvider<User?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return await repository.getProfile();
});