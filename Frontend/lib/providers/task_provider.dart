import 'package:flutter/foundation.dart';
import '../core/models/task.dart';
import '../core/models/live_update.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<Task> _tasks = [];
  List<LiveUpdate> _liveUpdates = [];
  bool _isLoading = false;
  String? _error;

  TaskProvider({required ApiService apiService}) : _apiService = apiService;

  // Getters
  List<Task> get tasks => _tasks;
  List<Task> get activeTasks => _tasks.where((t) => t.status == TaskStatus.running).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.status == TaskStatus.completed).toList();
  List<Task> get pendingTasks => _tasks.where((t) => t.status == TaskStatus.pending).toList();
  List<LiveUpdate> get liveUpdates => _liveUpdates;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get activeTaskCount => activeTasks.length;

  // Get task by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Fetch all tasks
  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _apiService.getTasks();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch single task
  Future<void> fetchTask(String taskId) async {
    try {
      final task = await _apiService.getTask(taskId);
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = task;
      } else {
        _tasks.add(task);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching task: $e');
      notifyListeners();
    }
  }

  // Create new task
  Future<Task?> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTask = await _apiService.createTask(
        title: title,
        description: description,
        priority: priority,
      );
      _tasks.insert(0, newTask);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return newTask;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      debugPrint('Error creating task: $e');
      notifyListeners();
      return null;
    }
  }

  // Stop task
  Future<void> stopTask(String taskId) async {
    try {
      final updatedTask = await _apiService.stopTask(taskId);
      _updateTask(updatedTask);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error stopping task: $e');
      notifyListeners();
    }
  }

  // Pause task
  Future<void> pauseTask(String taskId) async {
    try {
      final updatedTask = await _apiService.pauseTask(taskId);
      _updateTask(updatedTask);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error pausing task: $e');
      notifyListeners();
    }
  }

  // Resume task
  Future<void> resumeTask(String taskId) async {
    try {
      final updatedTask = await _apiService.resumeTask(taskId);
      _updateTask(updatedTask);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error resuming task: $e');
      notifyListeners();
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _apiService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting task: $e');
      notifyListeners();
    }
  }

  // Update task in list
  void _updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  // Add live update
  void addLiveUpdate(LiveUpdate update) {
    _liveUpdates.insert(0, update);
    // Keep only last 50 updates
    if (_liveUpdates.length > 50) {
      _liveUpdates = _liveUpdates.take(50).toList();
    }
    notifyListeners();
  }

  // Clear live updates
  void clearLiveUpdates() {
    _liveUpdates.clear();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh tasks (pull to refresh)
  Future<void> refreshTasks() async {
    await fetchTasks();
  }
}