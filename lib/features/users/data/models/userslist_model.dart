import 'package:users_hub/features/users/domain/entities/users_list.dart';

class UserslistModel extends UsersList {
  UserslistModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.avatar,
  
    
  });

  factory UserslistModel.fromJson(Map<String, dynamic> json) {
    return UserslistModel(
        id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }
}

