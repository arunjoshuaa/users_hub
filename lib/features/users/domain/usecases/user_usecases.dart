import 'package:users_hub/features/users/domain/entities/pagination.dart';
import 'package:users_hub/features/users/domain/entities/users_list.dart';
import 'package:users_hub/features/users/domain/repositories/userslist_repositories.dart';

/// Get list of users with pagination
class GetUsersUsecase {
  final UserslistRepositories repository;
  GetUsersUsecase(this.repository);

  Future<PaginatedUsers> call(int page) async {
    return await repository.getUsers(page);
  }
}

/// Get single user details
class GetUserUsecase {
  final UserslistRepositories repository;
  GetUserUsecase(this.repository);

  Future<UsersList> call(int id) async {
    return await repository.getUser(id);
  }
}

/// Create a new user
class CreateUserUsecase {
  final UserslistRepositories repository;
  CreateUserUsecase(this.repository);

  Future<UsersList> call(UsersList user) async {
    return await repository.createUser(user);
  }
}

/// Update existing user
class UpdateUserUsecase {
  final UserslistRepositories repository;
  UpdateUserUsecase(this.repository);

  Future<UsersList> call(int id, UsersList user) async {
    return await repository.updateUser(id, user );
  }
}

/// Delete a user
class DeleteUserUsecase {
  final UserslistRepositories repository;
  DeleteUserUsecase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteUser(id);
  }
}
