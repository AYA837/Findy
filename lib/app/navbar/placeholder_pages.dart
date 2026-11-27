import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/auth_service.dart';
import '../widgets/findy_bottom_nav.dart';
import 'placeholder_pages.dart'; // only valid if this file is also in lib/screens/

/// MVP placeholder pages. Replace any of these with your real screen later;
/// delete the matching class when you do.

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const _PagePlaceholder(
    title: 'Home',
    description: 'Your community feed: recently lost and found items near you.',
    icon: Icons.home_outlined,
  );
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) => const _PagePlaceholder(
    title: 'Search',
    description:
        'Browse and search lost and found items by keyword, '
        'category or place.',
    icon: Icons.search_rounded,
  );
}

/// Opened by the center PLUS button.
class CreatePage extends StatelessWidget {
  const CreatePage({super.key});
  @override
  Widget build(BuildContext context) {
    void soon() =>
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Coming soon')));
    return _PagePlaceholder(
      title: 'Create',
      description: 'Report a lost item or post something you found.',
      icon: Icons.add_circle_outline_rounded,
      isTab: false,
      footer: Column(
        children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: FindyNavColors.accent,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: soon,
            icon: const Icon(Icons.search_off_rounded),
            label: const Text('Report a lost item'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: FindyNavColors.active,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: soon,
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: const Text('Post a found item'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => _PagePlaceholder(
    title: 'Profile',
    description: 'Your account, your posts and your settings.',
    icon: Icons.person_outline_rounded,
    // Dev-only role switcher: hidden in release builds.
    footer: kDebugMode ? const _DevRoleSwitcher() : null,
  );
}

/// Visible to admins only.
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AuthService.instance,
    builder: (context, _) {
      if (!AuthService.instance.isAdmin) return const _AccessDenied();
      return const _PagePlaceholder(
        title: 'Admin Dashboard',
        description:
            'Manage users, communities and reported content '
            'across the whole platform.',
        icon: Icons.admin_panel_settings_outlined,
      );
    },
  );
}

/// Visible to community admins only.
class CommunityAdminPage extends StatelessWidget {
  const CommunityAdminPage({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AuthService.instance,
    builder: (context, _) {
      if (!AuthService.instance.isCommunityAdmin) {
        return const _AccessDenied();
      }
      return const _PagePlaceholder(
        title: 'Community Admin',
        description: 'Moderate items and members of your community.',
        icon: Icons.groups_outlined,
      );
    },
  );
}

// ---------------------------------------------------------------------------

class _AccessDenied extends StatelessWidget {
  const _AccessDenied();
  @override
  Widget build(BuildContext context) => const _PagePlaceholder(
    title: 'Access denied',
    description: 'You do not have permission to view this page.',
    icon: Icons.lock_outline_rounded,
  );
}

class _DevRoleSwitcher extends StatelessWidget {
  const _DevRoleSwitcher();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) => Column(
        children: [
          const Text(
            'DEV · mock role',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          SegmentedButton<UserRole>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              foregroundColor: Colors.white70,
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: FindyNavColors.accent,
            ),
            segments: [
              for (final r in UserRole.values)
                ButtonSegment(value: r, label: Text(r.label)),
            ],
            selected: {AuthService.instance.role},
            onSelectionChanged: (s) => AuthService.instance.setRole(s.first),
          ),
        ],
      ),
    );
  }
}

class _PagePlaceholder extends StatelessWidget {
  const _PagePlaceholder({
    required this.title,
    required this.description,
    required this.icon,
    this.isTab = true,
    this.footer,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isTab; // tabs have no back arrow; pushed pages do
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FindyNavColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: !isTab,
        backgroundColor: FindyNavColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: FindyNavColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: FindyNavColors.divider),
                  ),
                  child: Icon(icon, size: 38, color: FindyNavColors.active),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                if (footer != null) ...[const SizedBox(height: 28), footer!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
