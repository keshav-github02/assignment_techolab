import 'package:assignment_techolab/models/user.dart';

class UserService {
  final List<User> _users = [];

  // Create
  Future<User> createUser(User user) async {
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: user.name,
      photoUrl: user.photoUrl,
      email: user.email,
      phoneNumber: user.phoneNumber,
    );
    _users.add(newUser);
    return newUser;
  }

  // Read
  Future<List<User>> getUsers() async {
    return List<User>.from(_users); // return a copy
  }

  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update
  Future<User?> updateUser(User updatedUser) async {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      return updatedUser;
    }
    return null;
  }

  // Delete
  Future<bool> deleteUser(String id) async {
    final initialLength = _users.length;
    _users.removeWhere((user) => user.id == id);
    return _users.length < initialLength;
  }
}
