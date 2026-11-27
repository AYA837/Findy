import 'package:flutter/material.dart';

import 'mock_data.dart';
import 'community_home.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String _query = '';
  ReportType? _filter; // null = all

  Widget _filterChip(String label, ReportType? value) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == value,
      selectedColor: FindyColors.primary,
      onSelected: (_) => setState(() => _filter = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final q = _query.trim().toLowerCase();

        // Pinned reports first, then newest.
        final list = AppData.instance.sortedReports.where((r) {
          if (_filter != null && r.type != _filter) return false;
          if (q.isEmpty) return true;

          return r.name.toLowerCase().contains(q) ||
              r.category.toLowerCase().contains(q) ||
              r.location.toLowerCase().contains(q);
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const PageHeader(
              title: 'Lost & Found Items',
              subtitle: 'Browse',
            ),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search items',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _filterChip('All', null),
                _filterChip('Lost', ReportType.lost),
                _filterChip('Found', ReportType.found),
              ],
            ),
            const SizedBox(height: 16),
            SectionTitle('Items (${list.length})'),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No items match',
                    style: TextStyle(color: FindyColors.muted),
                  ),
                ),
              ),
            for (final r in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FindyCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ReportDetailPage(report: r),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemThumb(
                        r.category,
                        size: 56,
                        photoPath: r.photoPath,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (r.pinned)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.push_pin,
                                      size: 16,
                                      color: FindyColors.accent,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    r.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                typeChip(r.type),
                                statusChip(r),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${r.category} • ${r.location}',
                              style: const TextStyle(
                                color: FindyColors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              fmtDate(r.date),
                              style: const TextStyle(
                                color: FindyColors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
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
// Resolve / return dialog: who took the item, their phone, and when.
// ---------------------------------------------------------------------------

class ResolveInfo {
  const ResolveInfo(this.name, this.phone, this.date);

  final String name;
  final String phone;
  final DateTime date;
}

class _ResolveDialog extends StatefulWidget {
  const _ResolveDialog({
    required this.report,
    this.initialName = '',
  });

  final Report report;
  final String initialName;

  @override
  State<_ResolveDialog> createState() => _ResolveDialogState();
}

class _ResolveDialogState extends State<_ResolveDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initialName);

  final _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        ResolveInfo(
          _name.text.trim(),
          _phone.text.trim(),
          _date,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final found = widget.report.type == ReportType.found;

    return AlertDialog(
      backgroundColor: FindyColors.card,
      title: Text(
        found ? 'Who took this item?' : 'Who recovered this item?',
      ),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Record the hand-over of "${widget.report.name}".',
                style: const TextStyle(color: FindyColors.muted),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.event, size: 18),
                label: Text('Date: ${fmtDate(_date)}'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(
            found ? 'Mark as returned' : 'Mark as resolved',
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Report details
// ---------------------------------------------------------------------------

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({
    super.key,
    required this.report,
  });

  final Report report;

  Future<void> _resolve(
    BuildContext context, {
    String initialName = '',
  }) async {
    final info = await showDialog<ResolveInfo>(
      context: context,
      builder: (_) => _ResolveDialog(
        report: report,
        initialName: initialName,
      ),
    );

    if (info != null) {
      AppData.instance.resolveReport(
        report,
        info.name,
        info.phone,
        info.date,
      );
    }
  }

  Future<void> _rejectReturn(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Reject return report?',
      message:
          'The item will go back to Open. ${report.returnReportedBy ?? 'The member'} will not be recorded as having received it.',
      confirmLabel: 'Reject',
    );

    if (ok) {
      AppData.instance.rejectReturnReport(report);
    }
  }

  Future<void> _remove(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: 'Remove this report?',
      message:
          '"${report.name}" will be removed from the community. Use this for spam or inappropriate reports.',
      confirmLabel: 'Remove',
    );

    if (ok) {
      AppData.instance.removeReport(report);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // Pick an image and save its bytes.
  Future<void> _addPhoto(BuildContext context) async {
    final photo = await pickPhoto(context);

    if (photo != null) {
      AppData.instance.setReportPhoto(report, photo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report details'),
      ),
      body: ListenableBuilder(
        listenable: AppData.instance,
        builder: (context, _) {
          final found = report.type == ReportType.found;
          final open = report.status == ReportStatus.open;
          final review = report.status == ReportStatus.pendingReview;
          final resolved = report.status == ReportStatus.resolved;

          // This is now Uint8List image data, not a file path.
          final photo = report.photoPath;

          final placeholder = Center(
            child: Icon(
              categoryIcon(report.category),
              size: 72,
              color: FindyColors.accent,
            ),
          );

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    height: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: FindyColors.primary.withAlpha(60),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: FindyColors.border),
                    ),

                    // IMPORTANT: Image.memory instead of Image.file.
                    child: photo == null
                        ? placeholder
                        : Image.memory(
                            photo,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => placeholder,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _addPhoto(context),
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 18,
                      ),
                      label: Text(
                        photo == null ? 'Add photo' : 'Change photo',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (report.pinned)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.push_pin,
                            color: FindyColors.accent,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          report.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      typeChip(report.type),
                      statusChip(report),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FindyCard(
                    child: Column(
                      children: [
                        InfoRow('Category', report.category),
                        InfoRow('Date', fmtDate(report.date)),
                        InfoRow('Location', report.location),
                        InfoRow('Reported by', report.reporter),
                        InfoRow('Description', report.description),
                        InfoRow('Status', statusLabel(report)),
                      ],
                    ),
                  ),

                  // A member says the item was returned: admin verifies it.
                  if (review) ...[
                    const SizedBox(height: 12),
                    FindyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Return reported by a member',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InfoRow(
                            'Member',
                            report.returnReportedBy ?? '-',
                          ),
                          InfoRow(
                            'Note',
                            report.returnNote ?? '-',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _rejectReturn(context),
                                  child: const Text('Reject'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => _resolve(
                                    context,
                                    initialName: report.returnReportedBy ?? '',
                                  ),
                                  child: const Text('Verify'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Hand-over details, entered by the admin on resolve.
                  if (resolved) ...[
                    const SizedBox(height: 12),
                    FindyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            found ? 'Taken by' : 'Recovered by',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InfoRow('Name', report.resolvedBy ?? '-'),
                          InfoRow(
                            'Phone',
                            report.resolvedByPhone ?? '-',
                          ),
                          InfoRow(
                            'Date',
                            report.resolvedOn == null
                                ? '-'
                                : fmtDate(report.resolvedOn!),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  if (open) ...[
                    FilledButton.icon(
                      onPressed: () => _resolve(context),
                      icon: const Icon(Icons.check_circle),
                      label: Text(
                        found ? 'Mark as returned' : 'Mark as resolved',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  OutlinedButton.icon(
                    onPressed: () => AppData.instance.togglePin(report),
                    icon: Icon(
                      report.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                    ),
                    label: Text(
                      report.pinned ? 'Unpin' : 'Pin to top',
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _remove(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FindyColors.red,
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remove report'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
