import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/task.dart';
import '../core/models/task_step.dart';
import '../core/models/user.dart';

class ApiService {
  // TODO: Replace with your actual backend URL
  static const String baseUrl = 'http://localhost:8000/api';
  
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ==================== TASK ENDPOINTS ====================

  /// Get all tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/tasks'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error fetching tasks: $e');
    }
  }

  /// Get a single task by ID
  Future<Task> getTask(String taskId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to load task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error fetching task: $e');
    }
  }

  /// Create a new task
  Future<Task> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/tasks'),
        headers: _headers,
        body: json.encode({
          'title': title,
          'description': description,
          'priority': priority.name,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error creating task: $e');
    }
  }

  /// Update task status
  Future<Task> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/tasks/$taskId/status'),
        headers: _headers,
        body: json.encode({'status': status.name}),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error updating task: $e');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error deleting task: $e');
    }
  }

  /// Stop a running task
  Future<Task> stopTask(String taskId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/tasks/$taskId/stop'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to stop task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error stopping task: $e');
    }
  }

  /// Pause a running task
  Future<Task> pauseTask(String taskId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/tasks/$taskId/pause'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to pause task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error pausing task: $e');
    }
  }

  /// Resume a paused task
  Future<Task> resumeTask(String taskId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/tasks/$taskId/resume'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to resume task: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error resuming task: $e');
    }
  }

  // ==================== USER ENDPOINTS ====================

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/user/me'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error fetching user: $e');
    }
  }

  /// Update user profile
  Future<User> updateUser({
    String? name,
    String? email,
  }) async {
    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/user/me'),
        headers: _headers,
        body: json.encode({
          if (name != null) 'name': name,
          if (email != null) 'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw ApiException('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error updating user: $e');
    }
  }

  // ==================== FILE ENDPOINTS ====================

  /// Download task result file
  Future<List<int>> downloadTaskResult(String taskId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/tasks/$taskId/download'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw ApiException('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Error downloading file: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}