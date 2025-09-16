import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:users_hub/features/users/domain/entities/users_list.dart';
import 'package:users_hub/features/users/presentation/providers/userslist_provider.dart';
import 'package:users_hub/l10n/app_localizations.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentPage = 1;
   int _pageSize = 0;
  int _totalPages = 0;
  List<UsersList> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch users from API
Future<void> _fetchUsers() async {
  setState(() => _isLoading = true);

  try {
    // Get the PaginatedUsers response
    final paginated = await ref.refresh(
      usersListProvider(_currentPage).future,
    );

    setState(() {
      _users = paginated.users; // already a List<UsersList>
      _pageSize = paginated.perPage;     // ✅ assign perPage from API
      _totalPages = paginated.totalPages; // ✅ assign totalPages from API
      _currentPage = paginated.page;      // ✅ update current page from API
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching users: $e')),
    );
  }
}


  // Helper: show API response in a dialog
  void _showApiResponseDialog(String title, String message,BuildContext context) {
     final appLocalizations = AppLocalizations.of(context)!;  // Access localization here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
 title: Text(appLocalizations.userCreated),  // Use localized string      
    content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(appLocalizations.ok),
          ),
        ],
      ),
    );
  }

  // Show create user dialog
  void _showCreateUserDialog(BuildContext context) {
         final appLocalizations = AppLocalizations.of(context)!;  // Access localization here

    final firstnameController = TextEditingController();
    final lastnameController = TextEditingController();
    final emailController = TextEditingController();
    final avatarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(appLocalizations.createUser),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstnameController,
                decoration:  InputDecoration(labelText: appLocalizations.firstName),
              ),
              TextField(
                controller: lastnameController,
                decoration:  InputDecoration(labelText: appLocalizations.lastName),
              ),
              TextField(
                controller: emailController,
                decoration:  InputDecoration(labelText: appLocalizations.email),
              ),
              TextField(
                controller: avatarController,
                decoration:  InputDecoration(labelText: appLocalizations.avatarUrl),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(appLocalizations.cancel),
          ),
          Consumer(
            builder: (context, ref, _) {
              return ElevatedButton(
                onPressed: () async {
                  final createUser = ref.read(createUserUsecaseProvider);

                  final newUser = UsersList(
                    id: 0,
                    firstName: firstnameController.text,
                    lastName: lastnameController.text,
                    email: emailController.text,
                    avatar: avatarController.text,
                  );

                  try {
                    final responseModel = await createUser(newUser);

                    Navigator.pop(context);
                    _showApiResponseDialog(
                      "User Created",
                      "ID: ${responseModel.id}\n"
                          "Email: ${responseModel.email}\n"
                          "First Name: ${responseModel.firstName}\n"
                          "Last Name: ${responseModel.lastName}\n"
                          "Avatar: ${responseModel.avatar}",context
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    _showApiResponseDialog("Error", "Failed to create: $e",context);
                  }
                },
                child:  Text(appLocalizations.save),
              );
            },
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchUsers();
  }

  void _previousPage() {
    if (_currentPage == 1) return;
    setState(() {
      _currentPage--;
    });
    _fetchUsers();
  }

  @override
@override
Widget build(BuildContext context) {
  final appLocalizations = AppLocalizations.of(context)!;

  return Scaffold(
    appBar: AppBar(
      title: Text(appLocalizations.appName,style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,

    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: user.avatar.isNotEmpty
                                ? NetworkImage(user.avatar)
                                : null,
                            child: user.avatar.isEmpty
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          title: Text(
                            '${user.firstName} ${user.lastName}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(user.email),
                          onTap: () => context.push('/user/${user.id}'),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1 ? _previousPage : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(appLocalizations.previous),
                ),
                Text(
                  '${appLocalizations.page} $_currentPage / $_totalPages',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ElevatedButton(
                  onPressed: _currentPage < _totalPages ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(appLocalizations.next),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _showCreateUserDialog(context),
      icon: const Icon(Icons.add),
      label: Text(appLocalizations.addUser),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}

}
