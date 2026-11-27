import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'mock_data.dart';

// ---------------------------------------------------------------------------
// Shared colors, helpers and reusable widgets.
// Same design as the Findy Admin Dashboard (copied so the project is standalone).
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
  static const blue = Color(0xFF6EA8FF);
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

/// Small dialog with one required text field. Returns the text or null.
class TextInputDialog extends StatefulWidget {
  const TextInputDialog({
    super.key,
    required this.title,
    required this.label,
    required this.confirmLabel,
  });

  final String title;
  final String label;
  final String confirmLabel;

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _ctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _ctrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FindyColors.card,
      title: Text(widget.title),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _ctrl,
            autofocus: true,
            maxLines: 3,
            decoration: InputDecoration(labelText: widget.label),
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'This field is required' : null,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
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

/// Opens the gallery and returns the chosen photo as bytes (null if cancelled).
Future<Uint8List?> pickPhoto(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);

  try {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1400,
      imageQuality: 85,
    );

    if (file == null) return null;

    return await file.readAsBytes();
  } catch (_) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not open the photo picker')),
    );
    return null;
  }
}

/// Community photo (image bytes from settings) or a placeholder icon.
class CommunityImage extends StatelessWidget {
  const CommunityImage(this.photo, {super.key, this.size = 64});

  final Uint8List? photo;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = Center(
      child: Icon(Icons.groups, color: FindyColors.accent, size: size * 0.5),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: FindyColors.primary.withAlpha(90),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: FindyColors.accent.withAlpha(120)),
      ),
      child: photo == null
          ? placeholder
          : Image.memory(
              photo!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
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
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

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
                  Text(
                    subtitle!,
                    style: const TextStyle(color: FindyColors.muted),
                  ),
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
  const SectionTitle(
    this.text, {
    super.key,
    this.actionLabel,
    this.onAction,
  });

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
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
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
            child: Text(
              label,
              style: const TextStyle(color: FindyColors.muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemThumb extends StatelessWidget {
  const ItemThumb(
    this.category, {
    super.key,
    this.size = 48,
    this.photoPath,
  });

  final String category;
  final double size;
  final Uint8List? photoPath;

  @override
  Widget build(BuildContext context) {
    final icon = Center(
      child: Icon(
        categoryIcon(category),
        color: FindyColors.accent,
        size: size * 0.5,
      ),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: FindyColors.primary.withAlpha(70),
        borderRadius: BorderRadius.circular(14),
      ),
      child: photoPath == null
          ? icon
          : Image.memory(
              photoPath!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => icon,
            ),
    );
  }
}

// Lost / Found and report status chips (used by Home and Items)

Widget typeChip(ReportType t) => t == ReportType.lost
    ? const StatusChip('Lost', FindyColors.red)
    : const StatusChip('Found', FindyColors.green);

String statusLabel(Report r) {
  switch (r.status) {
    case ReportStatus.open:
      return 'Open';
    case ReportStatus.pendingReview:
      return 'Pending review';
    case ReportStatus.resolved:
      return r.type == ReportType.found ? 'Returned' : 'Resolved';
  }
}

Widget statusChip(Report r) {
  switch (r.status) {
    case ReportStatus.open:
      return StatusChip(statusLabel(r), FindyColors.amber);
    case ReportStatus.pendingReview:
      return StatusChip(statusLabel(r), FindyColors.blue);
    case ReportStatus.resolved:
      return StatusChip(statusLabel(r), FindyColors.accent);
  }
}

// ---------------------------------------------------------------------------
// Home
// ---------------------------------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onNavigate});

  /// Switches the main tab (0 Home, 1 Items, 2 Members, 3 Settings).
  final ValueChanged<int> onNavigate;

  Future<void> _announce(BuildContext context) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const TextInputDialog(
        title: 'New announcement',
        label: 'Message to your community',
        confirmLabel: 'Post',
      ),
    );

    if (text != null) AppData.instance.postAnnouncement(text);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final d = AppData.instance;
        final recent = d.sortedReports;

        Widget stat(
          IconData icon,
          String value,
          String label,
          int tab, {
          bool highlight = false,
        }) {
          return Expanded(
            child: FindyCard(
              highlight: highlight,
              onTap: () => onNavigate(tab),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: FindyColors.accent),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: FindyColors.muted,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final recentSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              'Recent lost & found',
              actionLabel: 'View all',
              onAction: () => onNavigate(2),
            ),
            FindyCard(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              child: Column(
                children: [
                  for (final r in recent.take(4))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          ItemThumb(
                            r.category,
                            size: 44,
                            photoPath: r.photoPath,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${r.location} • ${fmtDate(r.date)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: FindyColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (r.pinned)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.push_pin,
                                size: 16,
                                color: FindyColors.accent,
                              ),
                            ),
                          typeChip(r.type),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );

        final activitySection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              'Recent activity',
              actionLabel: 'Announce',
              onAction: () => _announce(context),
            ),
            FindyCard(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              child: Column(
                children: [
                  for (final a in d.activity.take(5))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            a.icon,
                            color: FindyColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  fmtDate(a.date),
                                  style: const TextStyle(
                                    color: FindyColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );

        return LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FindyCard(
                    highlight: true,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommunityImage(d.communityPhoto, size: 64),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your community',
                                    style: TextStyle(
                                      color: FindyColors.muted,
                                    ),
                                  ),
                                  Text(
                                    d.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(d.description),
                        if (d.phone.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _ContactLine(Icons.phone_outlined, d.phone),
                        ],
                        if (d.address.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _ContactLine(Icons.place_outlined, d.address),
                        ],
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () => onNavigate(3),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                          ),
                          label: const Text('Edit community'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      stat(
                        Icons.people,
                        '${d.members.length}',
                        'Total members',
                        3,
                        highlight: true,
                      ),
                      const SizedBox(width: 12),
                      stat(
                        Icons.search_off,
                        '${d.lostCount}',
                        'Lost reports',
                        2,
                      ),
                      const SizedBox(width: 12),
                      stat(
                        Icons.inventory_2,
                        '${d.foundCount}',
                        'Found reports',
                        2,
                      ),
                    ],
                  ),
                  if (d.guidelines.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    FindyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.rule,
                                color: FindyColors.accent,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Community guidelines',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(d.guidelines),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: recentSection),
                        const SizedBox(width: 16),
                        Expanded(child: activitySection),
                      ],
                    )
                  else ...[
                    recentSection,
                    const SizedBox(height: 20),
                    activitySection,
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

class _ContactLine extends StatelessWidget {
  const _ContactLine(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: FindyColors.muted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: FindyColors.muted),
          ),
        ),
      ],
    );
  }
}
