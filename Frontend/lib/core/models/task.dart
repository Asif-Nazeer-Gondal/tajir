import 'task_step.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime startTime;
  final DateTime? endTime;
  final int currentStep;
  final int totalSteps;
  final List<TaskStep> steps;
  final String? resultFileUrl;
  final String? resultFileName;
  final int? resultFileSize;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.startTime,
    this.endTime,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
    this.resultFileUrl,
    this.resultFileName,
    this.resultFileSize,
  });

  double get progress => totalSteps > 0 ? currentStep / totalSteps : 0.0;

  bool get isCompleted => status == TaskStatus.completed;
  bool get isRunning => status == TaskStatus.running;
  bool get isPending => status == TaskStatus.pending;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null 
          ? DateTime.parse(json['end_time'] as String)
          : null,
      currentStep: json['current_step'] as int,
      totalSteps: json['total_steps'] as int,
      steps: (json['steps'] as List<dynamic>)
          .map((step) => TaskStep.fromJson(step as Map<String, dynamic>))
          .toList(),
      resultFileUrl: json['result_file_url'] as String?,
      resultFileName: json['result_file_name'] as String?,
      resultFileSize: json['result_file_size'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'current_step': currentStep,
      'total_steps': totalSteps,
      'steps': steps.map((step) => step.toJson()).toList(),
      'result_file_url': resultFileUrl,
      'result_file_name': resultFileName,
      'result_file_size': resultFileSize,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? startTime,
    DateTime? endTime,
    int? currentStep,
    int? totalSteps,
    List<TaskStep>? steps,
    String? resultFileUrl,
    String? resultFileName,
    int? resultFileSize,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      steps: steps ?? this.steps,
      resultFileUrl: resultFileUrl ?? this.resultFileUrl,
      resultFileName: resultFileName ?? this.resultFileName,
      resultFileSize: resultFileSize ?? this.resultFileSize,
    );
  }
}

enum TaskStatus {
  pending,
  running,
  completed,
  failed,
  paused,
}

enum TaskPriority {
  low,
  medium,
  high,
}