import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../utils/logger.dart';

class ApiService {
  static const String baseUrl = 'https://reqres.in/api';
  final http.Client _client = http.Client();

  // Authentication
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/login'),
        body: request.toJson(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonResponse);
      } else {
        return AuthResponse(
          token: '',
          error: jsonResponse['error'] ?? 'Login failed',
        );
      }
    } catch (e) {
      AppLogger.error('Login error: $e');
      return AuthResponse(token: '', error: 'Network error occurred');
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/register'),
        body: request.toJson(),
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonResponse);
      } else {
        return AuthResponse(
          token: '',
          error: jsonResponse['error'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      AppLogger.error('Register error: $e');
      return AuthResponse(token: '', error: 'Network error occurred');
    }
  }

  // User Management
  Future<List<User>> getUsers({int page = 1}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users?page=$page'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        AppLogger.error('Failed to load users: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      AppLogger.error('Get users error: $e');
      return [];
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users/$id'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse['data']);
      } else {
        AppLogger.error('Failed to load user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      AppLogger.error('Get user by id error: $e');
      return null;
    }
  }

  Future<User?> createUser(User user) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/users'),
        body: {
          'name': '${user.firstName} ${user.lastName}',
          'job': 'user', // reqres.in doesn't actually store this data
        },
      );

      if (response.statusCode == 201) {
        // Since reqres.in doesn't actually create the user with our data,
        // we'll return the original user with the id from the response
        final jsonResponse = json.decode(response.body);
        return user.copyWith(id: int.tryParse(jsonResponse['id'].toString()) ?? 0);
      } else {
        AppLogger.error('Failed to create user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      AppLogger.error('Create user error: $e');
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/users/${user.id}'),
        body: {
          'name': '${user.firstName} ${user.lastName}',
          'job': 'user',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error('Update user error: $e');
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/users/$id'),
      );

      return response.statusCode == 204;
    } catch (e) {
      AppLogger.error('Delete user error: $e');
      return false;
    }
  }
}

