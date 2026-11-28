// ============================================================================
// lost_items_page.dart
// ----------------------------------------------------------------------------
// Page opened by pressing "See all" on the LOST items section of the
// community browse page. It lists ALL lost items of that community and lets
// the user narrow them down by category (UI only).
//
// FILE STRUCTURE
//   1. LostItemsPage        -> the screen (stateful: remembers the selected
//                              category chip)
//   2. Small reusable widgets, each with ONE responsibility:
//        - _LostItemsHeader   (back button + title + count)
//        - CategoryFilterBar  (horizontal chips: All / Wallets / Phones ...)
//        - _LostItemsListCard (card with red strip + scrollable list)
//        - _EmptyState        (shown when no item matches)
//
// It reuses these from community_browse_page.dart:
//   ReportedItem, ItemCategory, ItemStatus, ItemSearchBar, ItemListTile
// Colors come from app_colors.dart (AppColors).
//
// NOTE: Navigation and backend logic are NOT implemented here.
//       Every place that needs them is marked with a "TODO".
// ============================================================================

import 'package:flutter/material.dart';

import '/../../theme/app_colors.dart';
import '/../../Widgets/resuableWidgets.dart';
import 'browseScreen.dart';


// ---- Temporary sample data (UI preview only) -------------------------------
// TODO(backend): remove this and load ALL lost items of the community
// (with pagination, see the note in LostItemsPage.build).



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
  ReportedItem(
    id: 'lost-3',
    title: 'Brown card holder',
    category: ItemCategory.wallets,
    location: 'Cafeteria',
    reportedAt: DateTime.now().subtract(const Duration(days: 3)),
    status: ItemStatus.lost,
  ),
  ReportedItem(
    id: 'lost-4',
    title: 'Phone, cracked screen',
    category: ItemCategory.phones,
    location: 'Lecture hall A',
    reportedAt: DateTime.now().subtract(const Duration(hours: 4)),
    status: ItemStatus.lost,
  ),
  ReportedItem(
    id: 'lost-5',
    title: 'House keys, blue lanyard',
    category: ItemCategory.keys,
    location: 'Gym',
    reportedAt: DateTime.now().subtract(const Duration(hours: 6)),
    status: ItemStatus.lost,
  ),
  ReportedItem(
    id: 'lost-6',
    title: 'Power bank',
    category: ItemCategory.tech,
    location: 'Library',
    reportedAt: DateTime.now().subtract(const Duration(days: 5)),
    status: ItemStatus.lost,
  ),
];

// ============================================================================
// 1. LOST ITEMS PAGE
// ----------------------------------------------------------------------------
// StatefulWidget because it remembers ONE small piece of UI state:
// which category chip is selected.
// ============================================================================
class LostItemsPage extends StatefulWidget {
  /// Name of the community, shown under the title ("in University Campus").
  final String communityName;

  /// All lost items to display. When null, the temporary sample data is used.
  final List<ReportedItem>? items;

  const LostItemsPage({
    super.key,
    this.communityName = 'University Campus',
    this.items,
  });

  @override
  State<LostItemsPage> createState() => _LostItemsPageState();
}

class _LostItemsPageState extends State<LostItemsPage> {
  // null means "All" (no category filter).
  ItemCategory? _selectedCategory;

  /// Returns only the items matching the selected category chip.
  /// TODO(backend): if the list becomes large/paginated, send the selected
  /// category to the API instead of filtering on the device.
  List<ReportedItem> _applyCategoryFilter(List<ReportedItem> all) {
    if (_selectedCategory == null) return all;
    return all.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Fall back to sample data while the backend is not connected.
    final allItems = widget.items ?? _sampleLostItems;
    final visibleItems = _applyCategoryFilter(allItems);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ---- Header: back button + title + count ----
              _LostItemsHeader(
                communityName: widget.communityName,
                count: visibleItems.length,
                onBack: () {
                  // TODO(navigation): go back to the community browse page
                  // (e.g. Navigator.pop(context)).
                },
              ),
              const SizedBox(height: 20),

              // ---- Search (reuses the search bar of the browse page) ----
              const ItemSearchBar(hintText: 'Search lost items'),
              const SizedBox(height: 14),

              // ---- Category chips ----
              CategoryFilterBar(
                selected: _selectedCategory,
                onSelected: (category) {
                  // setState rebuilds the page with the new filter applied.
                  setState(() => _selectedCategory = category);
                },
              ),
              const SizedBox(height: 14),

              // ---- List (or empty state) ----
              // Expanded gives the card all the remaining screen height,
              // and the list scrolls INSIDE the card.
              Expanded(
                child: visibleItems.isEmpty
                    ? const _EmptyState()
                    : _LostItemsListCard(
                        items: visibleItems,
                        onItemTap: (item) {
                          // TODO(navigation): open the item details page,
                          // passing item.id.
                        },
                        onEndReached: () {
                          // TODO(backend): load the next page of lost items
                          // (infinite scroll), then append them to the list.
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 2. REUSABLE WIDGETS
// ============================================================================

// ----------------------------------------------------------------------------
// _LostItemsHeader: [back]  Lost items            (count)
//                           in University Campus
// ----------------------------------------------------------------------------
class _LostItemsHeader extends StatelessWidget {
  final String communityName;
  final int count;
  final VoidCallback onBack;

  const _LostItemsHeader({
    required this.communityName,
    required this.count,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ---- Rounded back button ----
        Material(
          color: AppColors.surface,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.surfaceBorder),
          ),
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // ---- Title + community name (takes all the remaining width) ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lost items',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'in $communityName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // ---- Number of items currently displayed ----
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.countBadge,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.countBadgeText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------------
// CategoryFilterBar: horizontally scrollable chips ("All" + every category).
// It is STATELESS: the selected value is owned by the page and passed in.
// ----------------------------------------------------------------------------
class CategoryFilterBar extends StatelessWidget {
  final ItemCategory? selected; // null = "All"
  final ValueChanged<ItemCategory?> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // One extra entry at index 0 for the "All" chip.
    final chipCount = ItemCategory.values.length + 1;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chipCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          // Index 0 -> "All", otherwise the matching category.
          final category = index == 0 ? null : ItemCategory.values[index - 1];

          return _FilterChip(
            label: category?.label ?? 'All',
            isSelected: category == selected,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}

// One rounded chip. Selected = red fill, unselected = dark with border.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(), // ripple follows the pill shape
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// _LostItemsListCard: card with the red "lost" strip on the left and a
// scrollable list of rows inside (same look as the browse page sections).
// ----------------------------------------------------------------------------
class _LostItemsListCard extends StatelessWidget {
  final List<ReportedItem> items;
  final ValueChanged<ReportedItem> onItemTap;
  final VoidCallback onEndReached; // called when the user scrolls to the end

  const _LostItemsListCard({
    required this.items,
    required this.onItemTap,
    required this.onEndReached,
  });

  // Width of the colored strip on the left edge of the card.
  static const double _accentWidth = 4;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias, // clips the strip to the rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      child: Stack(
        children: [
          // ---- Scrollable list ----
          // NotificationListener detects when the user reaches the bottom,
          // which is the hook for loading more items later.
          NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent) onEndReached();
              return false; // let other listeners receive the notification
            },
            // ListView.separated builds rows lazily (only the visible ones),
            // so it stays fast even with hundreds of items.
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 6, 16, 6),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemListTile(item: item, onTap: () => onItemTap(item));
              },
            ),
          ),

          // ---- Red strip on the left edge (full card height) ----
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _accentWidth,
            child: ColoredBox(color: AppColors.lostAccent),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// _EmptyState: message shown when no item matches the selected category.
// ----------------------------------------------------------------------------
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            'No lost items found',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}