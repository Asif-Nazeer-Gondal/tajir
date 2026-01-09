import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'services/api_service.dart';
import 'services/websocket_service.dart';
import 'providers/task_provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const ForexCompanionApp());
}

class ForexCompanionApp extends StatelessWidget {
  const ForexCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final apiService = ApiService();
    final websocketService = WebSocketService();

    return MultiProvider(
      providers: [
        // Providers
        ChangeNotifierProvider(
          create: (_) => TaskProvider(apiService: apiService)..fetchTasks(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(apiService: apiService)..fetchUser(),
        ),
        
        // Services
        Provider<ApiService>.value(value: apiService),
        Provider<WebSocketService>.value(value: websocketService),
      ],
      child: MaterialApp(
        title: 'Forex Companion',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.backgroundDark,
        ),
        routes: AppRoutes.routes,
        initialRoute: '/',
      ),
    );
  }
}