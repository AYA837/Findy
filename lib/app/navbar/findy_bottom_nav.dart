import 'package:flutter/material.dart';

import '../core/auth_service.dart';

/// Main navigation destinations (shown inside the bottom bar).
enum NavTab { home, search, profile, admin, community }

/// Tabs visible for a role. Admin and Community buttons are mutually exclusive.
List<NavTab> navTabsFor(UserRole role) => switch (role) {
      UserRole.user => const [NavTab.home, NavTab.search, NavTab.profile],
      UserRole.admin => const [
          NavTab.home,
          NavTab.search,
          NavTab.profile,
          NavTab.admin,
        ],
      UserRole.communityAdmin => const [
          NavTab.home,
          NavTab.search,
          NavTab.profile,
          NavTab.community,
        ],
    };

/// Colors taken from the Findy dark/crimson design. Point these to your theme
/// if you already have a central color file.
class FindyNavColors {
  static const background = Color(0xFF150508);
  static const surface = Color(0xFF2A0D12);
  static const divider = Color(0x33C21F3A);
  static const accent = Color(0xFFC21F3A); // PLUS button
  static const accentGlow = Color(0x8CC21F3A);
  static const active = Color(0xFFFF7A87);
  static const inactive = Color(0xFFE6D6D8);
}

class _NavSpec {
  const _NavSpec(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

const Map<NavTab, _NavSpec> _specs = {
  NavTab.home: _NavSpec(Icons.home_outlined, Icons.home_rounded, 'Home'),
  NavTab.search: _NavSpec(Icons.search_rounded, Icons.search_rounded, 'Search'),
  NavTab.profile:
      _NavSpec(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  NavTab.admin: _NavSpec(Icons.admin_panel_settings_outlined,
      Icons.admin_panel_settings, 'Admin'),
  NavTab.community:
      _NavSpec(Icons.groups_outlined, Icons.groups_rounded, 'Community'),
};

/// Reusable bottom navigation bar with a centered, elevated PLUS button.
///
/// Layout: [first two tabs] [PLUS] [remaining tabs]
///   user:      Home Search  (+)  Profile
///   admin:     Home Search  (+)  Profile Admin
///   community: Home Search  (+)  Profile Community
class FindyBottomNav extends StatelessWidget {
  const FindyBottomNav({
    super.key,
    required this.tabs,
    required this.current,
    required this.onTabSelected,
    required this.onCreate,
  });

  final List<NavTab> tabs;
  final NavTab current;
  final ValueChanged<NavTab> onTabSelected;
  final VoidCallback onCreate;

  static const double _barHeight = 64;
  static const double _fabSize = 58;
  static const double _overhang = 24; // how far the PLUS sticks out of the bar

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom; // safe area
    final left = tabs.take(2).toList();
    final right = tabs.skip(2).toList();

    Widget item(NavTab t) => Expanded(
          child: _NavItem(
            spec: _specs[t]!,
            selected: t == current,
            onTap: () => onTabSelected(t),
          ),
        );

    return Material(
      color: FindyNavColors.background,
      child: SizedBox(
        height: _overhang + _barHeight + bottomInset,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: _overhang),
              child: Container(
                padding: EdgeInsets.only(bottom: bottomInset),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: FindyNavColors.divider)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Row(children: left.map(item).toList())),
                    const SizedBox(width: _fabSize + 12),
                    Expanded(child: Row(children: right.map(item).toList())),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Semantics(
                button: true,
                label: 'Create',
                child: GestureDetector(
                  onTap: onCreate,
                  child: Container(
                    width: _fabSize,
                    height: _fabSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FindyNavColors.accent,
                      border: Border.all(
                          color: FindyNavColors.background, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: FindyNavColors.accentGlow,
                          blurRadius: 22,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _NavSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? FindyNavColors.active : FindyNavColors.inactive;
    return Semantics(
      button: true,
      selected: selected,
      label: spec.label,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? spec.activeIcon : spec.icon,
                color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              spec.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
