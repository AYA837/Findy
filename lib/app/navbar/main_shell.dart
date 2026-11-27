import 'package:flutter/material.dart';

import '../core/auth_service.dart';
import '../widgets/findy_bottom_nav.dart';
import 'placeholder_pages.dart'; // only valid if this file is also in lib/screens/

/// Hosts the single bottom navigation bar and the main sections.
/// Swap any placeholder in [_pageFor] with your existing screen
/// (e.g. your real community home) without touching the navigation logic.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AuthService _auth = AuthService.instance;
  NavTab _tab = NavTab.home;

  @override
  void initState() {
    super.initState();
    _auth.addListener(_onRoleChanged);
  }

  @override
  void dispose() {
    _auth.removeListener(_onRoleChanged);
    super.dispose();
  }

  void _onRoleChanged() {
    if (!mounted) return;
    setState(() {
      // If the current tab no longer exists for the new role, go Home.
      if (!navTabsFor(_auth.role).contains(_tab)) _tab = NavTab.home;
    });
  }

  Widget _pageFor(NavTab tab) => switch (tab) {
    NavTab.home => const HomePage(key: ValueKey('home')),
    NavTab.search => const SearchPage(key: ValueKey('search')),
    NavTab.profile => const ProfilePage(key: ValueKey('profile')),
    NavTab.admin => const AdminDashboardPage(key: ValueKey('admin')),
    NavTab.community => const CommunityAdminPage(key: ValueKey('community')),
  };

  void _openCreate() {
    // Pushed on top of the shell: full screen, no second nav bar,
    // back button returns to the section you were on.
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const CreatePage()));
  }

  @override
  Widget build(BuildContext context) {
    final tabs = navTabsFor(_auth.role);
    final i = tabs.indexOf(_tab);
    final index = i < 0 ? 0 : i;

    return PopScope(
      // Back on any tab other than Home returns to Home; back on Home exits.
      canPop: _tab == NavTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _tab = NavTab.home);
      },
      child: Scaffold(
        backgroundColor: FindyNavColors.background,
        body: IndexedStack(
          index: index,
          children: [for (final t in tabs) _pageFor(t)],
        ),
        bottomNavigationBar: FindyBottomNav(
          tabs: tabs,
          current: tabs[index],
          onTabSelected: (t) => setState(() => _tab = t),
          onCreate: _openCreate,
        ),
      ),
    );
  }
}
