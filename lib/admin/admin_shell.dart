import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'admin_management.dart';
import 'found_items.dart';
import 'main_app_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _titles = [
    'Main App',
    'Dashboard',
    'Found Items',
    'Categories',
    'Communities',
    'Members',
    'Profile',
  ];

  static const _shortTitles = [
    'Main App',
    'Home',
    'Items',
    'Categories',
    'Groups',
    'People',
  ];

  static const _icons = [
    Icons.home_outlined,
    Icons.dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.category_outlined,
    Icons.groups_outlined,
    Icons.people_outline,
    Icons.person_outline,
  ];

  // Main App opens separately without the Admin navigation.
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
      case 1:
        return DashboardPage(onNavigate: _go);
      case 2:
        return const FoundItemsPage();
      case 3:
        return const CategoriesPage();
      case 4:
        return const CommunitiesPage();
      case 5:
        return const MembersPage();
      default:
        return const ProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              leading: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Avatar('Findy Admin', size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Findy Admin',
                      style: TextStyle(
                        fontSize: 18,
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

    // Phone layout: bottom navigation (5 tabs), Profile via the avatar.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Findy Admin'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _index = 6),
              child: const Avatar('Findy Admin', size: 36),
            ),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index < 6 ? _index : 0,
        indicatorColor: _index < 6 ? FindyColors.primary : Colors.transparent,
        backgroundColor: FindyColors.card,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _go,
        destinations: [
          for (var i = 0; i < _shortTitles.length; i++)
            NavigationDestination(
              icon: Icon(_icons[i]),
              label: _shortTitles[i],
            ),
        ],
      ),
    );
  }
}
