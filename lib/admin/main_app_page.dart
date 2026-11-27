import 'package:flutter/material.dart';

import 'admin_dashboard.dart';

import '../main.dart';
import 'admin_shell.dart';
import 'main_app_page.dart';
import 'admin_dashboard.dart';
import 'admin_management.dart';
import 'found_items.dart';
import 'main_app_page.dart';

class MainAppPage extends StatelessWidget {
  const MainAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FindyColors.bg,
      appBar: AppBar(
        backgroundColor: FindyColors.bg,
        title: const Text(
          'Findy',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 80,
                  color: FindyColors.accent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Findy',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Helping people find what matters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: FindyColors.muted,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),
                _RoleCard(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Dashboard',
                  subtitle: 'Manage the Findy platform',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminShell(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: FindyColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: FindyColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                color: FindyColors.accent,
                size: 36,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: FindyColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 17,
                color: FindyColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
