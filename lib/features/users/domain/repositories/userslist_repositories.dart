import 'package:users_hub/features/users/data/models/userslist_model.dart';
import 'package:users_hub/features/users/domain/entities/pagination.dart';
import 'package:users_hub/features/users/domain/entities/users_list.dart';

abstract class UserslistRepositories {
  Future<PaginatedUsers>getUsers(int page);
    Future<UsersList> getUser(int id);
  Future<UsersList> createUser(UsersList data);
  Future<UsersList> updateUser(int id, UsersList data);
  Future<void> deleteUser(int id);
}