import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const DashboardScreen(),
    '/create-task': (_) => const Scaffold(
          body: Center(child: Text('Create Task Screen')),
        ),
    '/task-history': (_) => const Scaffold(
          body: Center(child: Text('Task History Screen')),
        ),
    '/settings': (_) => const Scaffold(
          body: Center(child: Text('Settings Screen')),
        ),
  };
}