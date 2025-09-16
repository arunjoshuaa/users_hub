import 'package:users_hub/features/users/data/models/pagenates_user_model.dart';
import 'package:users_hub/features/users/data/models/userslist_model.dart';
import 'package:dio/dio.dart';
abstract class UserslistRemoteDataSource {
 Future<PaginatedUsersModel> getUsers(int page);
     Future<UserslistModel> getUser(int id);
    Future<UserslistModel> createUser(UserslistModel data);
  Future<UserslistModel> updateUser(int id, UserslistModel data);
  Future<void> deleteUser(int id);
}

class UserslistRemoteDataSourceImpl implements UserslistRemoteDataSource {
  final Dio dio;
  UserslistRemoteDataSourceImpl()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://reqres.in/api/',
            headers: {'x-api-key': 'reqres-free-v1'},
          ),
        );
  @override
Future<PaginatedUsersModel> getUsers(int page) async {
  final response = await dio.get(
    'users',
    queryParameters: {'page': page},
  );

  return PaginatedUsersModel.fromJson(response.data);
}

   @override
  Future<UserslistModel> getUser(int id) async {
    final response = await dio.get('users/$id');
    print("response when getting details of one user is ${response.data}");
    return UserslistModel.fromJson(response.data['data']);
  }

  @override
Future<UserslistModel> createUser( data) async {
  // Convert entity to model
  final model = UserslistModel(
    id: data.id,
    firstName: data.firstName,
    lastName: data.lastName,
    email: data.email,
    avatar: data.avatar,
  );

  final response = await dio.post(
    'users',
    data: model.toJson(), // <-- send Map<String, dynamic>
  );
print("response after creating is ${response.data}");

  return UserslistModel.fromJson(response.data);
}


  @override
Future<UserslistModel> updateUser(int id, UserslistModel user) async {
  final model = UserslistModel(
    id: user.id,
    email: user.email,
    firstName: user.firstName,
    lastName: user.lastName,
    avatar: user.avatar,
  );

  final response = await dio.put(
    'users/$id',
    data: model.toJson(), // ✅ send JSON
  );
print("response after updating is ${response.data}");
  return UserslistModel.fromJson(response.data);
}


  @override
  Future<void> deleteUser(int id) async {
    
    final response =await dio.delete('users/$id');
    print( 'response after delete is ${response.data}');
  }
}

