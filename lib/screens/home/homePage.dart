// ============================================================================
// home_page.dart
// ----------------------------------------------------------------------------
// Home screen of the Lost & Found app (UI only).
//
// FILE STRUCTURE
//   1. AppColors            -> every color used in the page (single source)
//   2. Data models          -> simple classes holding the data shown in the UI
//   3. HomePage             -> the screen itself (assembles the widgets)
//   4. Small reusable widgets, each with ONE responsibility:
//        - HomeHeader, CommunitySearchBar, SectionTitle
//        - JoinedCommunityCard, DiscoverCommunityTile
//        - HomeBottomNavBar (+ _NavItem, _CenterActionButton)
//
// NOTE: Navigation and backend logic are NOT implemented here.
//       Every place that needs them is marked with a "TODO".
// ============================================================================

import 'package:flutter/material.dart';
import 'package:hello_ensia/screens/communities/browseScreen.dart';

// ============================================================================
// 1. COLORS
// ----------------------------------------------------------------------------
// All colors live here. To re-theme the app, only edit this class.
// The private constructor prevents anyone from creating an instance:
// we only use the static constants (AppColors.background, ...).
// ============================================================================
class AppColors {
  AppColors._();

  // ---- Backgrounds ---------------------------------------------------------
  static const Color background = Color(0xFF16060A); // page background
  static const Color surface = Color(0xFF220A10); // cards, search bar, nav bar
  static const Color surfaceBorder = Color(0xFF4A1822); // thin card outlines
  static const Color iconTile = Color(0xFF3A1019); // square icon container

  // ---- Brand / accent ------------------------------------------------------
  static const Color primary = Color(0xFFC41E3A); // main red (FAB, avatar)
  static const Color primaryLight = Color(0xFFE0455B); // icons on dark tiles
  static const Color primaryGlow = Color(0x66C41E3A); // soft glow (40% alpha)

  // ---- Highlighted ("live") card gradient ----------------------------------
  static const Color liveGradientStart = Color(0xFFC41E3A);
  static const Color liveGradientEnd = Color(0xFF6E0E1E);

  // ---- Text ----------------------------------------------------------------
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD9B8BD); // subtitles, hints
  static const Color textMuted = Color(
    0xFF9C7A80,
  ); // inactive nav, placeholders

  // ---- Buttons -------------------------------------------------------------
  static const Color buttonLight = Color(0xFFFBE9EC); // "Open" button fill
  static const Color buttonLightText = Color(0xFF4A0A14); // "Open" text

  // ---- Badges --------------------------------------------------------------
  static const Color badgeOnGradient = Color(0x40000000); // "Live now" pill
  static const Color badgeOnSurface = Color(0xFF3A1019); // "Enterprise" pill
}

// ============================================================================
// 2. DATA MODELS
// ----------------------------------------------------------------------------
// Plain Dart classes describing what the UI displays.
// TODO(backend): replace the sample lists below with data coming from your
// API / database (e.g. a repository or a state-management provider).
// ============================================================================

/// A community the user has already joined (top section "Your communities").
class JoinedCommunity {
  final String title; // e.g. "University Campus"
  final String locationLabel; // e.g. "Campus" (shown next to the pin icon)
  final String badgeLabel; // e.g. "Live now" / "Enterprise"
  final int newPostsToday; // number shown in "3 new posts today"
  final bool isHighlighted; // true -> red gradient card with a live dot

  const JoinedCommunity({
    required this.title,
    required this.locationLabel,
    required this.badgeLabel,
    required this.newPostsToday,
    this.isHighlighted = false,
  });

  /// Builds the "3 new posts today" text, handling singular/plural.
  String get newPostsText =>
      '$newPostsToday new ${newPostsToday == 1 ? 'post' : 'posts'} today';
}

/// A community the user can still join (bottom section "Discover communities").
class DiscoverCommunity {
  final String name; // e.g. "Grand Mall"
  final String category; // e.g. "Shopping center"

  const DiscoverCommunity({required this.name, required this.category});
}

// ---- Temporary sample data (UI preview only) -------------------------------
const List<JoinedCommunity> _sampleJoined = [
  JoinedCommunity(
    title: 'Ensia Campus',
    locationLabel: 'Mahelma',
    badgeLabel: 'Campus',
    newPostsToday: 3,
    isHighlighted: true,
  ),
  JoinedCommunity(
    title: 'Train Station EL Djamiaa',
    locationLabel: 'Sidi Abdallah',
    badgeLabel: 'Transport',
    newPostsToday: 1,
  ),
];

const List<DiscoverCommunity> _sampleDiscover = [
  DiscoverCommunity(name: 'Better Bodies Gym', category: 'Sports Center'),
  DiscoverCommunity(name: 'CyberParc', category: 'Scientific institution'),
];

// ============================================================================
// 3. HOME PAGE
// ----------------------------------------------------------------------------
// The screen. It only ASSEMBLES smaller widgets; it contains no styling
// details itself, which keeps it short and easy to read.
// ============================================================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Horizontal padding shared by every section of the page.
  static const double _horizontalPadding = 22;

  // Space reserved at the bottom so the last item is not hidden by the nav bar.
  static const double _bottomSpacing = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Stack lets us float the custom bottom navigation bar above the list.
      body: Stack(
        children: [
          // ---------------- Scrollable content ----------------
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                _horizontalPadding,
                16,
                _horizontalPadding,
                _bottomSpacing,
              ),
              children: [
                // TODO(backend): pass the real user name (from auth/profile).
                const HomeHeader(userName: '[Your name]', initials: 'AB'),
                const SizedBox(height: 20),

                // TODO(backend): filter the communities list as the user types.
                const CommunitySearchBar(),
                const SizedBox(height: 26),

                // ---- Your communities ----
                const SectionTitle('Your communities'),
                const SizedBox(height: 14),
                // The spread operator (...) inserts each generated card
                // directly into the ListView's children.
                ..._sampleJoined.map(
                  (community) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: JoinedCommunityCard(
                      community: community,
                      onOpen: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const CommunityBrowsePage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(
                                    1.0,
                                    0.0,
                                  ); // Start from bottom
                                  const end =
                                      Offset.zero; // End at normal position
                                  const curve = Curves.easeInOutCubicEmphasized;

                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ---- Discover communities ----
                const SectionTitle('Discover communities'),
                const SizedBox(height: 14),
                ..._sampleDiscover.map(
                  (community) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DiscoverCommunityTile(
                      community: community,
                      onJoin: () {
                        // TODO(backend): send a "join community" request, then
                        // move this community into "Your communities".
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Floating bottom navigation ----------------
        ],
      ),
    );
  }
}

// ============================================================================
// 4. REUSABLE WIDGETS
// ============================================================================

// ----------------------------------------------------------------------------
// HomeHeader: avatar + greeting + user name
// ----------------------------------------------------------------------------
class HomeHeader extends StatelessWidget {
  final String userName;
  final String initials; // letters displayed inside the avatar

  const HomeHeader({super.key, required this.userName, required this.initials});

  /// Returns a greeting that depends on the current hour of the day.
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 18) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ---- Circular avatar with initials ----
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary,
          child: Text(
            initials,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ---- Greeting + name ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// CommunitySearchBar: rounded search field (UI only)
// ----------------------------------------------------------------------------
class CommunitySearchBar extends StatelessWidget {
  const CommunitySearchBar({super.key});

  // Builds the rounded border; only the color changes between states.
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColors.textPrimary),
      cursorColor: AppColors.primaryLight,
      onChanged: (query) {
        // TODO(backend): search communities by name using [query]
        // (consider a debounce to avoid calling the API on every keystroke).
      },
      decoration: InputDecoration(
        hintText: 'Search communities',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: _border(AppColors.surfaceBorder),
        focusedBorder: _border(AppColors.primaryLight),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// SectionTitle: bold heading used above each list
// ----------------------------------------------------------------------------
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// JoinedCommunityCard: large card for a community the user already joined.
//   - isHighlighted == true  -> red gradient background + live dot
//   - isHighlighted == false -> dark surface background with a thin border
// ----------------------------------------------------------------------------
class JoinedCommunityCard extends StatelessWidget {
  final JoinedCommunity community;
  final VoidCallback onOpen; // action triggered by the "Open" button

  const JoinedCommunityCard({
    super.key,
    required this.community,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = community.isHighlighted;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        // Gradient for the highlighted card, flat color for the others.
        gradient: highlighted
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.liveGradientStart,
                  AppColors.liveGradientEnd,
                ],
              )
            : null,
        color: highlighted ? null : AppColors.surface,
        border: highlighted ? null : Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Top row: badge (left) + location (right) ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(
                label: community.badgeLabel,
                showLiveDot: highlighted,
              ),
              _LocationLabel(label: community.locationLabel),
            ],
          ),
          const SizedBox(height: 14),

          // ---- Community title ----
          Text(
            community.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),

          // ---- Bottom row: new posts text (left) + Open button (right) ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                community.newPostsText,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              _OpenButton(onPressed: onOpen),
            ],
          ),
        ],
      ),
    );
  }
}

// Small pill showing "Live now" / "Enterprise".
class _StatusBadge extends StatelessWidget {
  final String label;
  final bool showLiveDot; // white dot shown only for live communities

  const _StatusBadge({required this.label, required this.showLiveDot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: showLiveDot
            ? AppColors.badgeOnGradient
            : AppColors.badgeOnSurface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // shrink-wrap the pill to its content
        children: [
          if (showLiveDot) ...[
            const Icon(Icons.circle, size: 10, color: AppColors.textPrimary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Pin icon + short place name (top-right corner of the card).
class _LocationLabel extends StatelessWidget {
  final String label;

  const _LocationLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}

// Light rounded "Open" button used inside the community cards.
class _OpenButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _OpenButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonLight,
        foregroundColor: AppColors.buttonLightText,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        'Open',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// DiscoverCommunityTile: compact row for a community the user can join.
// ----------------------------------------------------------------------------
class DiscoverCommunityTile extends StatelessWidget {
  final DiscoverCommunity community;
  final VoidCallback onJoin; // action triggered by the "Join" button

  const DiscoverCommunityTile({
    super.key,
    required this.community,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          // ---- Square icon container ----
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.iconTile,
              borderRadius: BorderRadius.circular(14),
            ),
            // TODO(backend): use an icon/image that matches the community type.
            child: const Icon(
              Icons.apartment_rounded,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(width: 14),

          // ---- Name + category (takes all the remaining width) ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  community.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // ---- Outlined "Join" button ----
          OutlinedButton(
            onPressed: onJoin,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.primaryLight),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Join',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// HomeBottomNavBar: Home | Browse | (+) | Profile
// The round "+" button sits in the middle and overlaps the bar's top edge.
// ----------------------------------------------------------------------------
class HomeBottomNavBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onBrowseTap;
  final VoidCallback onAddTap;
  final VoidCallback onProfileTap;

  const HomeBottomNavBar({
    super.key,
    required this.onHomeTap,
    required this.onBrowseTap,
    required this.onAddTap,
    required this.onProfileTap,
  });

  static const double _barHeight = 72;
  static const double _buttonSize = 64;

  @override
  Widget build(BuildContext context) {
    // Respect the phone's bottom safe area (gesture bar / notch).
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // The container is taller than the visible bar so that the "+" button
    // stays INSIDE this widget's bounds (otherwise it would not be tappable).
    return SizedBox(
      height: _barHeight + _buttonSize / 2 + bottomInset,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ---- Visible bar ----
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: _barHeight + bottomInset,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    isActive: true, // TODO(navigation): drive from current tab
                    onTap: onHomeTap,
                  ),
                  _NavItem(
                    icon: Icons.search_rounded,
                    activeIcon: Icons.search_rounded,
                    label: 'Browse',
                    onTap: onBrowseTap,
                  ),
                  // Empty space where the floating "+" button sits.
                  const SizedBox(width: _buttonSize),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                    onTap: onProfileTap,
                  ),
                ],
              ),
            ),
          ),

          // ---- Floating "+" button ----
          _CenterActionButton(size: _buttonSize, onTap: onAddTap),
        ],
      ),
    );
  }
}

// One icon + label entry of the bottom bar.
class _NavItem extends StatelessWidget {
  final IconData icon; // icon when inactive
  final IconData activeIcon; // icon when active
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Active tab is bright, inactive tabs are muted.
    final color = isActive ? AppColors.textPrimary : AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// Big circular red button with a soft glow, shown at the center of the bar.
class _CenterActionButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _CenterActionButton({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          // Dark ring that "cuts" the button out of the bar + red glow.
          border: Border.all(color: AppColors.background, width: 4),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryGlow,
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.textPrimary,
          size: 34,
        ),
      ),
    );
  }
}
