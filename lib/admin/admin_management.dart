import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'mock_data.dart';

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  Future<void> _openForm(BuildContext context, {String? existing}) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _CategoryDialog(existing: existing),
    );

    if (name == null) return;

    if (existing == null) {
      AppData.instance.addCategory(name);
    } else {
      AppData.instance.renameCategory(existing, name);
    }
  }

  Future<void> _delete(BuildContext context, String name) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete category?',
      message: '"$name" will be removed from the list.',
      confirmLabel: 'Delete',
    );

    if (ok) AppData.instance.deleteCategory(name);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final cats = AppData.instance.categories;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageHeader(
              title: 'Categories',
              subtitle: '${cats.length} categories',
              action: FilledButton.icon(
                onPressed: () => _openForm(context),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ),
            for (final c in cats)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FindyCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(categoryIcon(c), color: FindyColors.accent),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          c,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () => _openForm(context, existing: c),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () => _delete(context, c),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: FindyColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({this.existing});

  final String? existing;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.existing ?? '');

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final t = (value ?? '').trim();

    if (t.isEmpty) return 'Name is required';

    final duplicate = AppData.instance.categories.any(
      (c) => c.toLowerCase() == t.toLowerCase() && c != widget.existing,
    );

    return duplicate ? 'This category already exists' : null;
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
      title: Text(widget.existing == null ? 'Add category' : 'Edit category'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Category name'),
          validator: _validate,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Communities
// ---------------------------------------------------------------------------

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  RequestStatus? _filter; // null = all

  Color _color(RequestStatus s) {
    switch (s) {
      case RequestStatus.pending:
        return FindyColors.amber;
      case RequestStatus.accepted:
        return FindyColors.green;
      case RequestStatus.rejected:
        return FindyColors.red;
    }
  }

  String _label(RequestStatus s) {
    switch (s) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.accepted:
        return 'Accepted';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }

  Future<void> _changeStatus(
    BuildContext context,
    Community c,
    RequestStatus status,
  ) async {
    if (c.status == status) return;

    final ok = await confirmDialog(
      context,
      title: 'Change community status?',
      message: '"${c.name}" will be changed to ${_label(status)}.',
      confirmLabel: 'Change status',
    );

    if (ok) {
      AppData.instance.setCommunityStatus(c, status);
    }
  }

  Widget _filterChip(String label, RequestStatus? value) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == value,
      selectedColor: FindyColors.primary,
      onSelected: (_) => setState(() => _filter = value),
    );
  }

  void _openCommunityDetails(BuildContext context, Community c) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _CommunityDetailsDialog(
          community: c,
          color: _color,
          label: _label,
          onChangeStatus: (status) => _changeStatus(dialogContext, c, status),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final all = AppData.instance.communities;

        final list = _filter == null
            ? all
            : all.where((c) => c.status == _filter).toList();

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageHeader(
              title: 'Communities',
              subtitle: '${all.length} communities',
            ),

            // Status filters
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _filterChip('All', null),
                _filterChip('Pending', RequestStatus.pending),
                _filterChip('Accepted', RequestStatus.accepted),
                _filterChip('Rejected', RequestStatus.rejected),
              ],
            ),

            const SizedBox(height: 16),

            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No communities here',
                    style: TextStyle(color: FindyColors.muted),
                  ),
                ),
              ),

            // Community cards
            for (final c in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FindyCard(
                  onTap: () => _openCommunityDetails(context, c),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusChip(_label(c.status), _color(c.status)),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right,
                            color: FindyColors.muted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created by ${c.creator} • ${fmtDate(c.requestDate)}',
                        style: const TextStyle(
                          color: FindyColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        c.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Click to view community details',
                        style: TextStyle(
                          color: FindyColors.accent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Community details popup
// ---------------------------------------------------------------------------

class _CommunityDetailsDialog extends StatelessWidget {
  const _CommunityDetailsDialog({
    required this.community,
    required this.color,
    required this.label,
    required this.onChangeStatus,
  });

  final Community community;
  final Color Function(RequestStatus) color;
  final String Function(RequestStatus) label;
  final ValueChanged<RequestStatus> onChangeStatus;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;

        final memberCount = data.members
            .where((m) => m.communities.contains(community.name))
            .length;

        final lostCount = data.lostItems
            .where((item) => item.community == community.name)
            .length;

        final foundCount =
            data.items.where((item) => item.community == community.name).length;

        return AlertDialog(
          backgroundColor: FindyColors.card,
          title: Row(
            children: [
              const Icon(
                Icons.groups,
                color: FindyColors.accent,
                size: 26,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  community.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.description,
                    style: const TextStyle(color: FindyColors.muted),
                  ),
                  const SizedBox(height: 18),

                  // Community information
                  const SectionTitle('Community information'),
                  InfoRow('Creator', community.creator),
                  InfoRow('Request date', fmtDate(community.requestDate)),
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text(
                          'Current status',
                          style: TextStyle(color: FindyColors.muted),
                        ),
                      ),
                      StatusChip(
                        label(community.status),
                        color(community.status),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Community statistics
                  const SectionTitle('Community statistics'),
                  Row(
                    children: [
                      Expanded(
                        child: _CommunityStat(
                          icon: Icons.people_outline,
                          label: 'Members',
                          value: memberCount,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _CommunityStat(
                          icon: Icons.search_off,
                          label: 'Lost items',
                          value: lostCount,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _CommunityStat(
                          icon: Icons.inventory_2_outlined,
                          label: 'Found items',
                          value: foundCount,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Change status
                  const SectionTitle('Change community status'),
                  const Text(
                    'You can change this status at any time, even if the '
                    'community was previously rejected.',
                    style: TextStyle(
                      color: FindyColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusButton(
                        RequestStatus.pending,
                        Icons.hourglass_empty,
                      ),
                      _statusButton(
                        RequestStatus.accepted,
                        Icons.check_circle_outline,
                      ),
                      _statusButton(
                        RequestStatus.rejected,
                        Icons.cancel_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),

            // TODO: Connect this button when the user-facing Community Page
            // has been created.
            FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.open_in_new),
              label: const Text('View Community Page'),
            ),

            /*
            When the user-facing community page exists, replace the
            onPressed: null above with navigation similar to this:

            onPressed: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityPage(community: community),
                ),
              );
            },
            */
          ],
        );
      },
    );
  }

  Widget _statusButton(RequestStatus status, IconData icon) {
    final isSelected = community.status == status;

    return OutlinedButton.icon(
      onPressed: isSelected ? null : () => onChangeStatus(status),
      icon: Icon(icon, size: 16),
      label: Text(label(status)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color(status),
        side: BorderSide(
          color: isSelected ? color(status) : color(status).withAlpha(100),
        ),
        backgroundColor:
            isSelected ? color(status).withAlpha(30) : Colors.transparent,
      ),
    );
  }
}

class _CommunityStat extends StatelessWidget {
  const _CommunityStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: FindyColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FindyColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: FindyColors.accent, size: 20),
          const SizedBox(height: 6),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FindyColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Members
// ---------------------------------------------------------------------------

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  void _openDetails(BuildContext context, Member m) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FindyColors.card,
        title: Row(
          children: [
            Avatar(m.name),
            const SizedBox(width: 12),
            Expanded(child: Text(m.name)),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow('Phone', m.phone),
              InfoRow('Registered', fmtDate(m.registered)),
              const SizedBox(height: 8),
              const Text(
                'Communities joined',
                style: TextStyle(color: FindyColors.muted),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in m.communities)
                    StatusChip(c, FindyColors.accent),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final members = AppData.instance.members;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageHeader(
              title: 'Members',
              subtitle: '${members.length} members',
            ),
            for (final m in members)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FindyCard(
                  onTap: () => _openDetails(context, m),
                  child: Row(
                    children: [
                      Avatar(m.name),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m.phone,
                              style: const TextStyle(
                                color: FindyColors.muted,
                              ),
                            ),
                            Text(
                              'Registered ${fmtDate(m.registered)}',
                              style: const TextStyle(
                                color: FindyColors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              'Communities: ${m.communities.join(', ')}',
                              style: const TextStyle(
                                color: FindyColors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: FindyColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
