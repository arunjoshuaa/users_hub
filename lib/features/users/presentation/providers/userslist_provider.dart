import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:users_hub/features/users/data/datasources/userslist_remote_data_source.dart';
import 'package:users_hub/features/users/data/repositories/userslist_repositories_impl.dart';
import 'package:users_hub/features/users/domain/entities/pagination.dart';
import 'package:users_hub/features/users/domain/entities/users_list.dart';
import 'package:users_hub/features/users/domain/repositories/userslist_repositories.dart';
import 'package:users_hub/features/users/domain/usecases/user_usecases.dart';

// Remote DataSource
final userRemoteDataSourceProvider = Provider<UserslistRemoteDataSource>(
  (ref) => UserslistRemoteDataSourceImpl(),
);

// Repository
final userRepositoryProvider = Provider<UserslistRepositories>(
  (ref) => UserslistRepositoriesImpl(ref.read(userRemoteDataSourceProvider)),
);

// ---------------- Usecase Providers ----------------

// Get paginated users
final getUsersUsecaseProvider = Provider<GetUsersUsecase>(
  (ref) => GetUsersUsecase(ref.read(userRepositoryProvider)),
);

// Get single user
final getUserUsecaseProvider = Provider<GetUserUsecase>(
  (ref) => GetUserUsecase(ref.read(userRepositoryProvider)),
);

// Create user
final createUserUsecaseProvider = Provider<CreateUserUsecase>(
  (ref) => CreateUserUsecase(ref.read(userRepositoryProvider)),
);

// Update user
final updateUserUsecaseProvider = Provider<UpdateUserUsecase>(
  (ref) => UpdateUserUsecase(ref.read(userRepositoryProvider)),
);

// Delete user
final deleteUserUsecaseProvider = Provider<DeleteUserUsecase>(
  (ref) => DeleteUserUsecase(ref.read(userRepositoryProvider)),
);

// ---------------- State Providers ----------------

// Users list (pagination)
final usersListProvider = FutureProvider.family<PaginatedUsers, int>((ref, page) async {
  final getUsers = ref.read(getUsersUsecaseProvider);
  return await getUsers(page);
});

// Single user details
final userDetailProvider = FutureProvider.family<UsersList, int>((ref, id) async {
  final getUser = ref.read(getUserUsecaseProvider);
  return await getUser(id);
});
