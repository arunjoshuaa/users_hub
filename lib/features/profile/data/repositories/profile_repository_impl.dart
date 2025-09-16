import 'package:users_hub/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:users_hub/features/profile/domain/entities/user.dart';
import 'package:users_hub/features/profile/domain/repositories/profile_repository.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveProfile(User user) async {
    final model = UserModel.fromEntity(user);
    await localDataSource.saveProfile(model);
  }

  @override
  Future<User?> getProfile() async {
    final model = await localDataSource.getProfile();
    return model?.toEntity();
  }

    @override
  Future<void> deleteProfile() async {
    await localDataSource.deleteProfile(); // 👈 delegate
  }
}
