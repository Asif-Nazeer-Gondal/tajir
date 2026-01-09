import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/task_creation/task_creation_screen.dart';
import '../features/task_history/task_history_screen.dart';
import '../features/settings/settings_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const DashboardScreen(),
    '/create-task': (_) => const TaskCreationScreen(),
    '/task-history': (_) => const TaskHistoryScreen(),
    '/settings': (_) => const SettingsScreen(),
  };
}