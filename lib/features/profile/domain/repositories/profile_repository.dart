import '../entities/user.dart';

abstract class ProfileRepository {
  Future<void> saveProfile(User user);
  Future<User?> getProfile();
   Future<void> deleteProfile();
}
