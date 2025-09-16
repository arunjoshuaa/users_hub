import 'package:users_hub/features/users/domain/entities/users_list.dart';

class PaginatedUsers {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UsersList> users;

  PaginatedUsers({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.users,
  });
}
