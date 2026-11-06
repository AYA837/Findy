import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
// Design tokens (copied from the design)
// ─────────────────────────────────────────────────────────────
class AppColors {
  static const background = Color(0xFF13060A);
  static const surface = Color(0xFF1D0A0F);
  static const searchFill = Color(0xFF1A080D);
  static const accent = Color(0xFFE0263F); // red ring, live dot
  static const accentLight = Color(0xFFFF8A9B); // "See all", Live text
  static const iconRed = Color(0xFFFF6B81); // item + section icons
  static const muted = Color(0xFFC4A0A7); // secondary text
  static const hint = Color(0xFFA8838A); // search placeholder
  static const cardBorder = Color(0xFF5C1824);
  static const tileFill = Color(0xFF2E0F17);
  static const tileBorder = Color(0xFF4A1A22);
  static const divider = Color(0xFF3A1118);
  static const appBarDivider = Color(0xFF2A0D14);
  static const badgeFill = Color(0xFF4A1520);
  static const badgeText = Color(0xFFFFB3BF);
  static const liveFill = Color(0xFF3A1018);
  static const avatarFill = Color(0xFF3A1118);
}

/// Plus Jakarta Sans text style helper (font used in the design).
TextStyle jakarta(double size, FontWeight weight, Color color) =>
    GoogleFonts.plusJakartaSans(
        fontSize: size, fontWeight: weight, color: color);

// ─────────────────────────────────────────────────────────────
// Model (UI only). Replace with your real data model.
// ─────────────────────────────────────────────────────────────
class ItemPreview {
  const ItemPreview({
    required this.title,
    required this.category,
    required this.location,
    required this.timeLabel,
    required this.icon,
  });

  final String title;
  final String category;
  final String location;

  /// LOGIC: compute from the post's timestamp (e.g. "2h", "1d").
  final String timeLabel;

  /// LOGIC: pick the icon from the item's category.
  final IconData icon;
}

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _searchController = TextEditingController();

  // LOGIC: replace these placeholders with data from your backend / state
  // management (e.g. a stream of posts for the selected community).
  static const _lostItems = [
    ItemPreview(
      title: 'Black leather wallet',
      category: 'Wallets',
      location: 'Library',
      timeLabel: '2h',
      icon: Icons.account_balance_wallet_outlined,
    ),
    ItemPreview(
      title: 'Phone, blue case',
      category: 'Phones',
      location: 'Block B',
      timeLabel: '1d',
      icon: Icons.smartphone_outlined,
    ),
  ];

  static const _foundItems = [
    ItemPreview(
      title: 'Car keys, red tag',
      category: 'Keys',
      location: 'Cafeteria',
      timeLabel: '5h',
      icon: Icons.vpn_key_outlined,
    ),
    ItemPreview(
      title: 'Laptop charger',
      category: 'Tech',
      location: 'Lecture hall A',
      timeLabel: '2d',
      icon: Icons.electrical_services_outlined,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // The bottom navigation bar (Home / Browse / + / Profile) is NOT part of
      // this file. Add it in the parent shell or via Scaffold.bottomNavigationBar.
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25,),
            BrowseAppBar(
              
              // LOGIC: read username and photo URL from the logged-in user.
              username: '[Username]',
              profileImageUrl: null,
              onProfileTap: () {
                // LOGIC: navigate to the profile page.
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                // Bottom padding leaves room for the navbar you add later.
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommunityHeader(
                      // LOGIC: name of the community the user selected.
                      communityName: 'University Campus',
                      // LOGIC: show the pill only while the realtime
                      // connection / feed is live.
                    
                    ),
                    const SizedBox(height: 14),
                    SearchField(
                      controller: _searchController,
                      onChanged: (query) {
                        // LOGIC: filter both lists (debounce ~300 ms,
                        // then query local state or the backend).
                      },
                    ),
                    const SizedBox(height: 16),
                    ItemsSection(
                      title: 'Lost items',
                      headerIcon: Icons.search,
                      items: _lostItems,
                      onSeeAll: () {
                        
                      },
                      onItemTap: (item) {
                        // LOGIC: open the item details page
                        // (owner can contact the poster).
                      },
                    ),
                    const SizedBox(height: 14),
                    ItemsSection(
                      title: 'Found items',
                      headerIcon: Icons.check,
                      items: _foundItems,
                      onSeeAll: () {
                        // LOGIC: open the full list of found items.
                      },
                      onItemTap: (item) {
                        // LOGIC: open the item details page.
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// App bar: profile picture + username
// ─────────────────────────────────────────────────────────────
class BrowseAppBar extends StatelessWidget {
  const BrowseAppBar({
    super.key,
    required this.username,
    this.profileImageUrl,
    this.onProfileTap,
  });

  final String username;
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.appBarDivider)),
      ),
      child: Row(
        children: [
          ProfileAvatarButton(imageUrl: profileImageUrl, onTap: onProfileTap),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back',
                  style: jakarta(12, FontWeight.w400, AppColors.muted)),
              const SizedBox(height: 1),
              Text(username,
                  style: jakarta(16, FontWeight.w800, Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({super.key, this.imageUrl, this.onTap});

  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(Icons.person_outline,
        size: 26, color: AppColors.badgeText);

    return Semantics(
      button: true,
      label: 'Open profile',
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Container(
          width: 46,
          height: 46,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.avatarFill,
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: imageUrl == null
              ? fallback
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => fallback,
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// "Browse in / University Campus" + Live pill
// ─────────────────────────────────────────────────────────────
class CommunityHeader extends StatelessWidget {
  const CommunityHeader({
    super.key,
    required this.communityName,
   
  });

  final String communityName;
 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Browse in',
                style: jakarta(11, FontWeight.w400, AppColors.muted)),
            const SizedBox(height: 1),
            Text(communityName,
                style: jakarta(20, FontWeight.w800, Colors.white)),
          ],
        ),
        const Spacer(),
        
      ],
    );
  }
}

class LivePill extends StatelessWidget {
  const LivePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.liveFill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.accent),
          ),
          const SizedBox(width: 6),
          Text('Live',
              style: jakarta(11, FontWeight.w700, AppColors.accentLight)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Search field
// ─────────────────────────────────────────────────────────────
class SearchField extends StatelessWidget {
  const SearchField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border() => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.tileBorder),
        );

    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        cursorColor: AppColors.accent,
        style: jakarta(13, FontWeight.w400, Colors.white),
        decoration: InputDecoration(
          hintText: 'Search lost or found items',
          hintStyle: jakarta(13, FontWeight.w400, AppColors.hint),
          filled: true,
          fillColor: AppColors.searchFill,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: border(),
          enabledBorder: border(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.accent),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Lost / Found card
// ─────────────────────────────────────────────────────────────
class ItemsSection extends StatelessWidget {
  const ItemsSection({
    super.key,
    required this.title,
    required this.headerIcon,
    required this.items,
    this.onSeeAll,
    this.onItemTap,
  });

  final String title;
  final IconData headerIcon;
  final List<ItemPreview> items;
  final VoidCallback? onSeeAll;
  final ValueChanged<ItemPreview>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 6),
            child: Row(
              children: [
                Icon(headerIcon, size: 15, color: AppColors.iconRed),
                const SizedBox(width: 8),
                Text(title,
                    style: jakarta(14, FontWeight.w800, Colors.white)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.badgeFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // LOGIC: use the total count from the backend if the
                  // preview only contains the first few items.
                  child: Text('${items.length}',
                      style:
                          jakarta(11, FontWeight.w700, AppColors.badgeText)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onSeeAll,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('See all',
                        style: jakarta(
                            12, FontWeight.w700, AppColors.accentLight)),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(
                  height: 1, thickness: 1, color: AppColors.divider),
            ItemRow(
              item: items[i],
              onTap: onItemTap == null ? null : () => onItemTap!(items[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow({super.key, required this.item, this.onTap});

  final ItemPreview item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.tileFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.tileBorder),
              ),
              child: Icon(item.icon, size: 22, color: AppColors.iconRed),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: jakarta(14, FontWeight.w700, Colors.white)),
                  const SizedBox(height: 2),
                  Text('${item.category} · ${item.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: jakarta(11.5, FontWeight.w400, AppColors.muted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(item.timeLabel,
                style: jakarta(12, FontWeight.w400, AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Optional: run this file alone to preview the screen.
// ─────────────────────────────────────────────────────────────
