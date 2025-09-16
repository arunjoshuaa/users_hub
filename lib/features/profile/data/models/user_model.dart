import 'package:users_hub/features/profile/domain/entities/user.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String phoneno;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneno,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phoneno: json['phoneno'] as String,
        avatar: json['avatar'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phoneno':phoneno,
        'avatar': avatar,
      };

  // DB map (same as toJson)
  Map<String, dynamic> toDb() => toJson();

  factory UserModel.fromDb(Map<String, dynamic> dbRow) => UserModel(
        id: dbRow['id'] as String,
        name: dbRow['name'] as String,
        email: dbRow['email'] as String,
        avatar: dbRow['avatar'] as String?,
        phoneno: dbRow['phoneno'] as String,
      );

  User toEntity() => User(id: id, name: name, email: email, avatar: avatar,phoneno: phoneno);

  static UserModel fromEntity(User user) => UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        phoneno: user.phoneno
      );
}
