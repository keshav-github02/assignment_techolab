import 'package:assignment_techolab/screens/user/user_detail_screen.dart';
import 'package:assignment_techolab/screens/user/user_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/load_overlay.dart';
import '../../widgets/user_list_item.dart';
import 'auth/login_screen.dart';
import 'package:assignment_techolab/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUsers();
  }

  Future<void> _refreshUsers() async {
    await Provider.of<UserProvider>(context, listen: false).loadUsers();
  }

  void _navigateToUserDetail(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(userId: userId),
      ),
    );
  }

  void _navigateToAddUser() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const UserFormScreen(),
      ),
    );
  }

  Future<void> _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return LoadingOverlay(
      isLoading: userProvider.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Management'),
          centerTitle: true,
          backgroundColor: theme.colorScheme.primary,
          elevation: 3,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshUsers,
          child: userProvider.users.isEmpty && userProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : userProvider.users.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 72,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshUsers,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 16),
            itemCount: userProvider.users.length +
                (userProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == userProvider.users.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final user = userProvider.users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: UserListItem(
                  user: user,
                  onTap: () {
                    if (user.id != null) {
                      _navigateToUserDetail(context, user.id!);
                    }
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddUser,
          tooltip: 'Add User',
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
