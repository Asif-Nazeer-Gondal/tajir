import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.sidebarDark,
      child: Column(
        children: [
          // Logo & App Name
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 36,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Forex Companion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Navigation Items
          _NavItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isActive: true,
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          _NavItem(
            icon: Icons.add_circle_outline,
            label: 'Task Creation',
            onTap: () => Navigator.pushNamed(context, '/create-task'),
          ),
          _NavItem(
            icon: Icons.history,
            label: 'Task History',
            onTap: () => Navigator.pushNamed(context, '/task-history'),
          ),
          _NavItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          
          const Spacer(),
          
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Notification Bell
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white54),
                      onPressed: () {},
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryGreen,
                      child: const Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sohaib',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Free Plan',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  icon: const Icon(Icons.settings, size: 16, color: Colors.white54),
                  label: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primaryBlue : Colors.white54,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}