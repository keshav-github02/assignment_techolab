import 'package:flutter/foundation.dart';
import 'package:assignment_techolab/models/user.dart';
import 'package:assignment_techolab/utils/database_helper.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  User? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserProvider() {
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await DatabaseHelper.instance.database;
      await loadUsers();
    } catch (e) {
      _error = 'Error initializing database';
      print('Error initializing database: $e');
    }
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await DatabaseHelper.instance.getAllUsers();
      _error = null;
    } catch (e) {
      _error = 'Error loading users';
      print('Error loading users: $e');
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserById(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedUser = _users.firstWhere((user) => user.id == id);
      _error = null;
    } catch (e) {
      _error = 'User not found';
      _selectedUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseHelper.instance.createUser(user);
      await loadUsers();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error creating user';
      print('Error creating user: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUser(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
      await loadUsers();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error updating user';
      print('Error updating user: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUser(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseHelper.instance.deleteUser(id);
      await loadUsers();
      _error = null;
      return true;
    } catch (e) {
      _error = 'Error deleting user';
      print('Error deleting user: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
