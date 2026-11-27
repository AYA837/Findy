import 'package:flutter/material.dart';

import 'mock_data.dart';

// ---------------------------------------------------------------------------
// Shared colors, helpers and small reusable widgets (used by all screens)
// ---------------------------------------------------------------------------

class FindyColors {
  static const bg = Color(0xFF140508);
  static const card = Color(0xFF2B0D13);
  static const border = Color(0xFF4A1A24);
  static const primary = Color(0xFFB71C2E);
  static const accent = Color(0xFFFF6B7D);
  static const muted = Color(0xFFC9A0A7);
  static const green = Color(0xFF4CD08B);
  static const red = Color(0xFFFF5A5F);
  static const amber = Color(0xFFFFB74D);
}

String fmtDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

String initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  return parts.take(2).map((p) => p[0]).join().toUpperCase();
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Technology':
      return Icons.smartphone;
    case 'Electronics':
      return Icons.headphones;
    case 'Clothes':
      return Icons.checkroom;
    case 'Books':
      return Icons.menu_book;
    case 'Wallets':
      return Icons.account_balance_wallet;
    case 'Keys':
      return Icons.vpn_key;
    case 'Accessories':
      return Icons.watch;
    case 'Documents':
      return Icons.description;
    case 'Bags':
      return Icons.backpack;
    case 'Jewelry':
      return Icons.diamond;
    default:
      return Icons.category;
  }
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: FindyColors.card,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key, this.size = 44});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: FindyColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials(name),
        style: TextStyle(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FindyCard extends StatelessWidget {
  const FindyCard({
    super.key,
    required this.child,
    this.onTap,
    this.highlight = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool highlight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return Container(
      decoration: BoxDecoration(
        color: highlight ? null : FindyColors.card,
        gradient: highlight
            ? const LinearGradient(
                colors: [Color(0xFF9B1B2C), Color(0xFF3A0E16)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: radius,
        border: Border.all(color: FindyColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, this.color, {super.key});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(140)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader(
      {super.key, required this.title, this.subtitle, this.action});
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(color: FindyColors.muted)),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.actionLabel, this.onAction});
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child:
                Text(label, style: const TextStyle(color: FindyColors.muted)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// Placeholder button: will open the user's home page once that screen exists.

class ItemThumb extends StatelessWidget {
  const ItemThumb(this.category, {super.key, this.size = 48});
  final String category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FindyColors.primary.withAlpha(70),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(categoryIcon(category),
          color: FindyColors.accent, size: size * 0.5),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.onNavigate});

  /// Switches the main navigation tab (see tab order in main.dart).
  final ValueChanged<int> onNavigate;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 18) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final d = AppData.instance;
        final stats = <_Stat>[
          _Stat(Icons.people, '${d.members.length}', 'Total members', 5,
              highlight: true),
          _Stat(Icons.apartment, '${d.acceptedCommunities}',
              'Total communities', 4),
          _Stat(Icons.search_off, '${d.lostItemsCount}', 'Total lost items', 2),
          _Stat(Icons.inventory_2, '${d.items.length}', 'Total found items', 2),
          _Stat(Icons.hourglass_top, '${d.pendingRequests.length}',
              'Pending requests', 4),
        ];

        final recent = [...d.items]
          ..sort((a, b) => b.dateFound.compareTo(a.dateFound));

        return LayoutBuilder(
          builder: (context, c) {
            const pad = 20.0;
            const gap = 12.0;
            final avail = c.maxWidth - pad * 2;
            final cols = c.maxWidth >= 900 ? 5 : (c.maxWidth >= 600 ? 3 : 2);
            final cardW = (avail - gap * (cols - 1)) / cols;
            final wide = c.maxWidth >= 900;

            final recentSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('Recently found items',
                    actionLabel: 'View all', onAction: () => onNavigate(2)),
                FindyCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: Column(
                    children: [
                      for (final item in recent.take(4))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ItemThumb(item.category, size: 44),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      '${item.category} • ${fmtDate(item.dateFound)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: FindyColors.muted,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              item.claim == ClaimStatus.claimed
                                  ? const StatusChip(
                                      'Claimed', FindyColors.green)
                                  : const StatusChip(
                                      'Unclaimed', FindyColors.amber),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );

            final pending = d.pendingRequests;
            final pendingSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('Pending community requests',
                    actionLabel: 'Review', onAction: () => onNavigate(4)),
                FindyCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: pending.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text('No pending requests',
                                style: TextStyle(color: FindyColors.muted)),
                          ),
                        )
                      : Column(
                          children: [
                            for (final r in pending)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          Text(
                                            'by ${r.creator} • ${fmtDate(r.requestDate)}',
                                            style: const TextStyle(
                                                color: FindyColors.muted,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const StatusChip(
                                        'Pending', FindyColors.amber),
                                  ],
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Avatar('Findy Admin'),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_greeting(),
                              style: const TextStyle(color: FindyColors.muted)),
                          const Text('Findy Admin',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final s in stats)
                        SizedBox(
                          width: cardW,
                          child: FindyCard(
                            highlight: s.highlight,
                            onTap:
                                s.tab == null ? null : () => onNavigate(s.tab!),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(s.icon, color: FindyColors.accent),
                                const SizedBox(height: 14),
                                Text(s.value,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900)),
                                Text(s.label,
                                    style: const TextStyle(
                                        color: FindyColors.muted,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: recentSection),
                        const SizedBox(width: 16),
                        Expanded(child: pendingSection),
                      ],
                    )
                  else ...[
                    recentSection,
                    const SizedBox(height: 20),
                    pendingSection,
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Stat {
  const _Stat(this.icon, this.value, this.label, this.tab,
      {this.highlight = false});
  final IconData icon;
  final String value;
  final String label;
  final int? tab;
  final bool highlight;
}

// ---------------------------------------------------------------------------
// Profile (placeholder)
// ---------------------------------------------------------------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const PageHeader(title: 'Profile', subtitle: 'Admin account'),
        FindyCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Avatar('Findy Admin', size: 80),
              const SizedBox(height: 14),
              const Text('Findy Admin',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const Text('admin@findy.app',
                  style: TextStyle(color: FindyColors.muted)),
              const SizedBox(height: 16),
              const Divider(color: FindyColors.border),
              const InfoRow('Role', 'Administrator'),
              const InfoRow('Status', 'Active'),
              const SizedBox(height: 8),
              const Text(
                'Placeholder profile. Account settings will be added later.',
                textAlign: TextAlign.center,
                style: TextStyle(color: FindyColors.muted),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Sign out is not implemented yet')),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
