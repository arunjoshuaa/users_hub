import 'package:users_hub/features/users/data/datasources/userslist_remote_data_source.dart';
import 'package:users_hub/features/users/data/models/pagenates_user_model.dart';
import 'package:users_hub/features/users/data/models/userslist_model.dart';
import 'package:users_hub/features/users/domain/entities/pagination.dart';
import 'package:users_hub/features/users/domain/entities/users_list.dart';
import 'package:users_hub/features/users/domain/repositories/userslist_repositories.dart';

class UserslistRepositoriesImpl implements UserslistRepositories {
  final UserslistRemoteDataSource remoteDataSource;

  UserslistRepositoriesImpl(this.remoteDataSource);

@override

Future<PaginatedUsers> getUsers(int page) async {
  final response = await remoteDataSource.getUsers(page);

  return PaginatedUsers(
    page: response.page,
    perPage: response.perPage,
    total: response.total,
    totalPages: response.totalPages,
    users: response.data
        .map(
          (m) => UsersList(
            id: m.id,
            email: m.email,
            firstName: m.firstName,
            lastName: m.lastName,
            avatar: m.avatar,
          ),
        )
        .toList(),
  );
}



  @override
  Future<UsersList> getUser(int id) async {
    final model = await remoteDataSource.getUser(id);
    return model;
  }

  @override
  Future<UsersList> createUser(UsersList data) async {
    final model = UserslistModel(
    id: data.id,
    firstName: data.firstName,
    lastName: data.lastName,
    email: data.email,
    avatar: data.avatar,
  );
   // Call remote data source
  final createdModel = await remoteDataSource.createUser(model);
  // Return as entity (UsersList)
  return UsersList(
    id: createdModel.id,
    firstName: createdModel.firstName,
    lastName: createdModel.lastName,
    email: createdModel.email,
    avatar: createdModel.avatar,
  );      
  }
  

  @override
  Future<UsersList> updateUser(int id, UsersList user) async {
    final model = UserslistModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      avatar: user.avatar,
    );
    final updated = await remoteDataSource.updateUser(id, model);
    return updated;
  }

  @override
  Future<void> deleteUser(int id) {
    return remoteDataSource.deleteUser(id);
  }
}
