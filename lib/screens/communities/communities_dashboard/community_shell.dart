import 'package:flutter/material.dart';

import 'main_app_page.dart';
import 'community_home.dart';
import 'community_items.dart';
import 'community_members.dart';
import 'mock_data.dart';

class CommunityShell extends StatefulWidget {
  const CommunityShell({super.key});

  @override
  State<CommunityShell> createState() => _CommunityShellState();
}

class _CommunityShellState extends State<CommunityShell> {
  int _index = 0;

  static const _titles = [
    'Main App',
    'Home',
    'Items',
    'Members',
    'Settings',
  ];

  static const _icons = [
    Icons.home_outlined,
    Icons.dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.people_outline,
    Icons.settings_outlined,
  ];

  void _go(int i) {
    if (i == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainAppPage(),
        ),
      );
    } else {
      setState(() => _index = i);
    }
  }

  Widget _page() {
    switch (_index) {
      case 0:
        return const MainAppPage();
      case 1:
        return HomePage(onNavigate: _go);
      case 2:
        return const ItemsPage();
      case 3:
        return const MembersPage();
      default:
        return const SettingsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        if (AppData.instance.deleted) {
          return const _DeletedView();
        }

        final wide = MediaQuery.of(context).size.width >= 900;

        final body = Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: KeyedSubtree(
              key: ValueKey(_index),
              child: _page(),
            ),
          ),
        );

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: true,
                  selectedIndex: _index,
                  onDestinationSelected: _go,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommunityImage(
                          AppData.instance.communityPhoto,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Findy Community',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  destinations: [
                    for (var i = 0; i < _titles.length; i++)
                      NavigationRailDestination(
                        icon: Icon(_icons[i]),
                        label: Text(_titles[i]),
                      ),
                  ],
                ),
                const VerticalDivider(
                  width: 1,
                  color: FindyColors.border,
                ),
                Expanded(child: body),
              ],
            ),
          );
        }

        // Phone layout: bottom navigation.
        return Scaffold(
          appBar: AppBar(
            title: Text(AppData.instance.name),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CommunityImage(
                  AppData.instance.communityPhoto,
                  size: 36,
                ),
              ),
            ],
          ),
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            indicatorColor: FindyColors.primary,
            backgroundColor: FindyColors.card,
            surfaceTintColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: _go,
            destinations: [
              // Main App: opens a separate page.
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Main App',
              ),

              // Other community pages.
              for (var i = 1; i < _titles.length; i++)
                NavigationDestination(
                  icon: Icon(_icons[i]),
                  label: _titles[i],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Shown after the community is deleted (mock only).
/// Lets you restore the mock data so you can keep testing.
class _DeletedView extends StatelessWidget {
  const _DeletedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete_outline,
                size: 56,
                color: FindyColors.accent,
              ),
              const SizedBox(height: 12),
              const Text(
                'Community deleted',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'This community no longer exists.',
                style: TextStyle(
                  color: FindyColors.muted,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: AppData.instance.reset,
                child: const Text('Restore mock community'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
