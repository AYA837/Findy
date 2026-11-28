// ============================================================================
// community_browse_page.dart
// ----------------------------------------------------------------------------
// Page shown after opening a community (e.g. "University Campus").
// It lists the community's LOST items and FOUND items (UI only).
//
// FILE STRUCTURE
//   1. Data models          -> ItemStatus, ItemCategory, ReportedItem
//   2. CommunityBrowsePage  -> the screen itself (assembles the widgets)
//   3. Small reusable widgets, each with ONE responsibility:
//        - BrowseHeader (+ _LivePill)
//        - ItemSearchBar
//        - ItemsSectionCard (+ _SectionHeader, _CountBadge)
//        - ItemListTile
//
// Colors come from app_colors.dart (AppColors).
//
// NOTE: Navigation and backend logic are NOT implemented here.
//       Every place that needs them is marked with a "TODO".
// ============================================================================

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

// ============================================================================
// 1. DATA MODELS
// ----------------------------------------------------------------------------
// Plain Dart types describing what the UI displays.
// ============================================================================

/// Whether an item was lost by someone, or found by someone.
enum ItemStatus { lost, found }

/// Category of an item. Each category knows its own label and icon, so the UI
/// never needs a big if/else to pick them.
/// TODO(backend): add the categories your API supports (bags, ID cards, ...).
/// 
/// 
enum ItemCategory {
  wallets('Wallets', Icons.account_balance_wallet_outlined),
  phones('Phones', Icons.smartphone_rounded),
  keys('Keys', Icons.vpn_key_outlined),
  tech('Tech', Icons.power_outlined);

  final String label; // text shown in the subtitle
  final IconData icon; // icon shown inside the square tile

  const ItemCategory(this.label, this.icon);
}

/// One lost or found item reported inside a community.
class ReportedItem {
  final String id; // needed later to open the item details page
  final String title; // e.g. "Black leather wallet"
  final ItemCategory category;
  final String location; // e.g. "Library"
  final DateTime reportedAt; // when the post was created
  final ItemStatus status;

  const ReportedItem({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.reportedAt,
    required this.status,
  });

  /// Subtitle shown under the title, e.g. "Wallets · Library".
  String get subtitle => '${category.label} · $location';

  /// Short relative time shown on the right, e.g. "2h", "1d".
  String get timeAgo {
    final diff = DateTime.now().difference(reportedAt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

// ---- Temporary sample data (UI preview only) -------------------------------
// TODO(backend): remove these and load the real items of the community
// (e.g. from a repository / provider), separated by ItemStatus.
final List<ReportedItem> _sampleLostItems = [
  ReportedItem(
    id: 'lost-1',
    title: 'Black leather wallet',
    category: ItemCategory.wallets,
    location: 'Library',
    reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
    status: ItemStatus.lost,
  ),
  ReportedItem(
    id: 'lost-2',
    title: 'Phone, blue case',
    category: ItemCategory.phones,
    location: 'Block B',
    reportedAt: DateTime.now().subtract(const Duration(days: 1)),
    status: ItemStatus.lost,
  ),
];


//dummy data of found items and lost items
final List<ReportedItem> _sampleFoundItems = [
  ReportedItem(
    id: 'found-1',
    title: 'Car keys, red tag',
    category: ItemCategory.keys,
    location: 'Cafeteria',
    reportedAt: DateTime.now().subtract(const Duration(hours: 5)),
    status: ItemStatus.found,
  ),
  ReportedItem(
    id: 'found-2',
    title: 'Laptop charger',
    category: ItemCategory.tech,
    location: 'Lecture hall A',
    reportedAt: DateTime.now().subtract(const Duration(days: 2)),
    status: ItemStatus.found,
  ),
];

// ============================================================================
// 2. COMMUNITY BROWSE PAGE
// ----------------------------------------------------------------------------
// The screen. It only ASSEMBLES smaller widgets; it contains no styling
// details itself, which keeps it short and easy to read.
// ============================================================================
class CommunityBrowsePage extends StatelessWidget {
  /// Name displayed in the header (comes from the community the user opened).
  final String communityName;

  /// Whether the community is currently "live" (shows the Live pill).
  final bool isLive;

  /// Items to display. When null, the temporary sample data is used.
  final List<ReportedItem>? lostItems;
  final List<ReportedItem>? foundItems;

  const CommunityBrowsePage({
    super.key,
    this.communityName = 'Ensia Campus',
    this.isLive = true,
    this.lostItems,
    this.foundItems,
  });

  // Padding shared by the whole page content.
  static const double _pagePadding = 20;

  @override
  Widget build(BuildContext context) {
    // Fall back to sample data while the backend is not connected.
    final lost = lostItems ?? _sampleLostItems;
    final found = foundItems ?? _sampleFoundItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(_pagePadding),
          children: [
            // TODO(navigation): add a back button here (or in an AppBar) to
            // return to the Home page.
            // TODO(backend): receive the community id from the Home page and
            // use it to load this community's name, live status and items.
            BrowseHeader(communityName: communityName, isLive: isLive),
            const SizedBox(height: 20),

            // TODO(backend): filter both lists as the user types.
         
            const SizedBox(height: 20),

            // ---------------- Lost items ----------------
            ItemsSectionCard(
              title: 'Lost items',
              headerIcon: Icons.search_rounded,
              accentColor: AppColors.lostAccent,
              items: lost,
              onSeeAll: () {
                // TODO(navigation): open the full list of LOST items
                // of this community.
              },
              onItemTap: _openItemDetails,
            ),
            const SizedBox(height: 18),

            // ---------------- Found items ----------------
            ItemsSectionCard(
              title: 'Found items',
              headerIcon: Icons.check_rounded,
              accentColor: AppColors.foundAccent,
              items: found,
              onSeeAll: () {
                // TODO(navigation): open the full list of FOUND items
                // of this community.
              },
              onItemTap: _openItemDetails,
            ),
          ],
        ),
      ),
    );
  }

  /// Shared handler for tapping any item (lost or found).
  void _openItemDetails(ReportedItem item) {
    // TODO(navigation): open the item details page, passing item.id.
  }
}

// ============================================================================
// 3. REUSABLE WIDGETS
// ============================================================================

// ----------------------------------------------------------------------------
// BrowseHeader: "Browse in" + community name on the left, Live pill on the right
// ----------------------------------------------------------------------------
class BrowseHeader extends StatelessWidget {
  final String communityName;
  final bool isLive;

  const BrowseHeader({
    super.key,
    required this.communityName,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Title block (takes all the remaining width) ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Browse in',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                communityName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}

// Small rounded pill: dot + "Live".
class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.livePillBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, // shrink-wrap the pill to its content
        children: [
          Icon(Icons.circle, size: 10, color: AppColors.liveDot),
          SizedBox(width: 6),
          Text(
            'Live',
            style: TextStyle(
              color: AppColors.accentText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

//----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// ItemsSectionCard: a card with a colored left strip, a header
// (icon + title + count + "See all") and a list of items.
// Used twice: once for LOST items and once for FOUND items.
// ----------------------------------------------------------------------------
class ItemsSectionCard extends StatelessWidget {
  final String title; // "Lost items" / "Found items"
  final IconData headerIcon; // icon shown before the title
  final Color accentColor; // color of the left strip
  final List<ReportedItem> items;
  final VoidCallback onSeeAll; // action of the "See all" button
  final ValueChanged<ReportedItem> onItemTap; // action when a row is tapped

  const ItemsSectionCard({
    super.key,
    required this.title,
    required this.headerIcon,
    required this.accentColor,
    required this.items,
    required this.onSeeAll,
    required this.onItemTap,
  });

  // Width of the colored strip on the left edge of the card.
  static const double _accentWidth = 4;

  @override
  Widget build(BuildContext context) {
    // Material (instead of Container) so the tap ripple of the rows is visible
    // and the corners clip the left strip nicely.
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      child: Stack(
        children: [
          // ---- Card content ----
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 16, 6),
            child: Column(
              children: [
                _SectionHeader(
                  title: title,
                  icon: headerIcon,
                  // TODO(backend): use the TOTAL count returned by the API
                  // (this list may only contain the latest few items).
                  count: items.length,
                  onSeeAll: onSeeAll,
                ),
                const SizedBox(height: 8),

                // Rows separated by thin dividers. The inner list literal
                // with "..." inserts the divider + tile pair for each item.
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.divider,
                    ),
                  ItemListTile(
                    item: items[i],
                    onTap: () => onItemTap(items[i]),
                  ),
                ],
              ],
            ),
          ),

          // ---- Colored strip on the left edge (full card height) ----
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _accentWidth,
            child: ColoredBox(color: accentColor),
          ),
        ],
      ),
    );
  }
}

// Header row of a section: icon + title + count badge ... "See all".
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.count,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accentText),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        _CountBadge(count: count),
        const Spacer(), // pushes "See all" to the far right
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentText,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See all',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

// Small rounded badge showing the number of items.
class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.countBadge,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: AppColors.countBadgeText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// ItemListTile: one row = icon tile | title + subtitle | time ago
// ----------------------------------------------------------------------------
class ItemListTile extends StatelessWidget {
  final ReportedItem item;
  final VoidCallback onTap;

  const ItemListTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // ---- Square gradient tile with the category icon ----
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.itemTileStart, AppColors.itemTileEnd],
                ),
              ),
              // TODO(backend): if items have photos, show a thumbnail here
              // instead of the category icon.
              child: Icon(
                item.category.icon,
                color: AppColors.itemIcon,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // ---- Title + subtitle (takes all the remaining width) ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ---- Relative time ("2h", "1d") ----
            Text(
              item.timeAgo,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}