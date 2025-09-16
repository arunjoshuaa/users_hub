import 'package:users_hub/features/users/data/models/userslist_model.dart';

class PaginatedUsersModel {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserslistModel> data;

  PaginatedUsersModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory PaginatedUsersModel.fromJson(Map<String, dynamic> json) {
    return PaginatedUsersModel(
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
      data: (json['data'] as List)
          .map((e) => UserslistModel.fromJson(e))
          .toList(),
    );
  }
}
