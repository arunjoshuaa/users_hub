import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:users_hub/config/connectivity_watcher.dart';
import 'package:users_hub/features/users/domain/entities/users_list.dart';
import 'package:users_hub/features/users/presentation/providers/userslist_provider.dart';
import 'package:users_hub/l10n/app_localizations.dart';

class UserDetailsScreen extends ConsumerWidget {
  final int userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(userId));
     final appLocalizations = AppLocalizations.of(context)!;  // Access localization here

    return ConnectivityWatcher(
      child: Scaffold(
        appBar: AppBar(
          title:  Text(appLocalizations.userDetail,style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: userAsync.when(
          data: (user) => Center(
            child: SingleChildScrollView(
          //    padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Profile Header Card
                  Card( 
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                  padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
            
                  /// Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon:  Icon(Icons.edit),
                        label:  Text(appLocalizations.edit),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showEditDialog(context, ref, user),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label:  Text(appLocalizations.delete),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final deleteUser = ref.read(deleteUserUsecaseProvider);
                          await deleteUser(user.id);
            
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("User deleted")),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text("Error: $err"),
          ),
        ),
      ),
    );
  }

  /// Edit User Dialog
  void _showEditDialog(BuildContext context, WidgetRef ref, UsersList user) {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedUser = user.copyWith(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
              );

              final updateUser = ref.read(updateUserUsecaseProvider);

              try {
                final response = await updateUser(user.id, updatedUser);

                if (context.mounted) {
                  Navigator.pop(ctx);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("User Updated"),
                      content: Text(
                        "ID: ${response.id}\n"
                        "Email: ${response.email}\n"
                        "First Name: ${response.firstName}\n"
                        "Last Name: ${response.lastName}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update user: $e")),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
