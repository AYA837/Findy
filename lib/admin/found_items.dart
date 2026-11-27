import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'mock_data.dart';

// ---------------- CLAIM STATUS CHIP ----------------

Widget _claimChip(ClaimStatus s) => s == ClaimStatus.claimed
    ? const StatusChip('Claimed', FindyColors.green)
    : const StatusChip('Unclaimed', FindyColors.amber);

// ---------------- ITEMS PAGE ----------------

class FoundItemsPage extends StatefulWidget {
  const FoundItemsPage({super.key});

  @override
  State<FoundItemsPage> createState() => _FoundItemsPageState();
}

class _FoundItemsPageState extends State<FoundItemsPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All categories';
  String _selectedType = 'All';
  String _selectedClaimStatus = 'All';
  String _selectedLocation = 'All locations';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;

        final locations = <String>{
          ...data.items.map((item) => item.location),
          ...data.lostItems.map((item) => item.location),
        }.toList()
          ..sort();

        final categories = [
          'All categories',
          ...data.categories,
        ];

        final allItems = <Widget>[];

        final search = _searchController.text.toLowerCase().trim();

        // Filter Found items.
        if (_selectedType == 'All' || _selectedType == 'Found') {
          for (final item in data.items) {
            final matchesSearch = item.name.toLowerCase().contains(search) ||
                item.location.toLowerCase().contains(search);

            final matchesCategory = _selectedCategory == 'All categories' ||
                item.category == _selectedCategory;

            final matchesLocation = _selectedLocation == 'All locations' ||
                item.location == _selectedLocation;

            final matchesClaim = _selectedClaimStatus == 'All' ||
                (_selectedClaimStatus == 'Claimed' &&
                    item.claim == ClaimStatus.claimed) ||
                (_selectedClaimStatus == 'Unclaimed' &&
                    item.claim == ClaimStatus.unclaimed);

            if (matchesSearch &&
                matchesCategory &&
                matchesLocation &&
                matchesClaim) {
              allItems.add(_buildFoundCard(context, item));
            }
          }
        }

        // Filter Lost items.
        if (_selectedType == 'All' || _selectedType == 'Lost') {
          for (final item in data.lostItems) {
            final matchesSearch = item.name.toLowerCase().contains(search) ||
                item.location.toLowerCase().contains(search);

            final matchesCategory = _selectedCategory == 'All categories' ||
                item.category == _selectedCategory;

            final matchesLocation = _selectedLocation == 'All locations' ||
                item.location == _selectedLocation;

            // Claim status applies only to Found items.
            final matchesClaim = _selectedClaimStatus == 'All';

            if (matchesSearch &&
                matchesCategory &&
                matchesLocation &&
                matchesClaim) {
              allItems.add(_buildLostCard(context, item));
            }
          }
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageHeader(
              title: 'Items Management',
              subtitle: '${data.totalItemsCount} total items',
            ),

            const SizedBox(height: 20),

            // SEARCH
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by item name or place...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FILTERS
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 600;

                final filters = [
                  _buildDropdown(
                    'Category',
                    _selectedCategory,
                    categories,
                    (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  _buildDropdown(
                    'Type',
                    _selectedType,
                    ['All', 'Lost', 'Found'],
                    (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  _buildDropdown(
                    'Claim status',
                    _selectedClaimStatus,
                    ['All', 'Claimed', 'Unclaimed'],
                    (value) {
                      setState(() {
                        _selectedClaimStatus = value!;
                      });
                    },
                  ),
                  _buildDropdown(
                    'Location',
                    _selectedLocation,
                    ['All locations', ...locations],
                    (value) {
                      setState(() {
                        _selectedLocation = value!;
                      });
                    },
                  ),
                ];

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: filters.map((filter) {
                    return SizedBox(
                      width: isSmall
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 12) / 2,
                      child: filter,
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 12),

            // RESET FILTERS
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  _searchController.clear();

                  setState(() {
                    _selectedCategory = 'All categories';
                    _selectedType = 'All';
                    _selectedClaimStatus = 'All';
                    _selectedLocation = 'All locations';
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset filters'),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '${allItems.length} results found',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: FindyColors.muted,
              ),
            ),

            const SizedBox(height: 12),

            if (allItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text('No items match your filters.'),
                ),
              )
            else
              ...allItems,
          ],
        );
      },
    );
  }

  // ---------------- DROPDOWN ----------------

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // ---------------- FOUND CARD ----------------

  Widget _buildFoundCard(
    BuildContext context,
    FoundItem item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FindyCard(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => FoundItemDetailPage(item: item),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemThumb(item.category, size: 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      StatusChip(
                        'Found',
                        FindyColors.green,
                      ),
                      const SizedBox(width: 6),
                      _claimChip(item.claim),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _Meta(Icons.label_outline, item.category),
                      _Meta(Icons.event, fmtDate(item.dateFound)),
                      _Meta(Icons.place_outlined, item.location),
                      _Meta(Icons.person_outline, item.finderName),
                      if (item.claimedBy != null)
                        _Meta(
                          Icons.how_to_reg_outlined,
                          'Claimed by ${item.claimedBy}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- LOST CARD ----------------

  Widget _buildLostCard(
    BuildContext context,
    LostItem item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FindyCard(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => LostItemDetailPage(item: item),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemThumb(item.category, size: 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const StatusChip(
                        'Lost',
                        FindyColors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _Meta(Icons.label_outline, item.category),
                      _Meta(Icons.event, fmtDate(item.dateLost)),
                      _Meta(Icons.place_outlined, item.location),
                      _Meta(Icons.person_outline, item.reporterName),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- META INFORMATION ----------------

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: FindyColors.muted,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: FindyColors.muted,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}

// ---------------- CLAIM DIALOG ----------------

class _ClaimDialog extends StatefulWidget {
  const _ClaimDialog({required this.itemName});

  final String itemName;

  @override
  State<_ClaimDialog> createState() => _ClaimDialogState();
}

class _ClaimDialogState extends State<_ClaimDialog> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime _claimedOn = DateTime.now();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _claimedOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select claim date',
    );

    if (selectedDate != null) {
      setState(() {
        _claimedOn = selectedDate;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'date': _claimedOn,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FindyColors.card,
      title: const Text('Who took this item?'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Record the person who recovered "${widget.itemName}".',
                style: const TextStyle(
                  color: FindyColors.muted,
                ),
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
                  labelText: 'Phone (optional)',
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Claim date',
                  style: TextStyle(
                    color: FindyColors.muted,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(fmtDate(_claimedOn)),
                ),
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
          child: const Text('Mark as claimed'),
        ),
      ],
    );
  }
}

// ---------------- FOUND ITEM DETAILS ----------------

class FoundItemDetailPage extends StatelessWidget {
  const FoundItemDetailPage({
    super.key,
    required this.item,
  });

  final FoundItem item;

  Future<void> _toggleClaim(BuildContext context) async {
    if (item.claim == ClaimStatus.claimed) {
      final ok = await confirmDialog(
        context,
        title: 'Mark as unclaimed?',
        message:
            'The recorded claimer (${item.claimedBy}) will be removed and the item will be shown as waiting for its owner again.',
      );

      if (ok) {
        AppData.instance.unclaimItem(item);
      }

      return;
    }

    final who = await showDialog<Map<String, Object>>(
      context: context,
      builder: (_) => _ClaimDialog(itemName: item.name),
    );

    if (who != null) {
      AppData.instance.claimItem(
        item,
        who['name'] as String,
        who['phone'] as String,
        who['date'] as DateTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item details'),
      ),
      body: ListenableBuilder(
        listenable: AppData.instance,
        builder: (context, _) {
          final claimed = item.claim == ClaimStatus.claimed;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    height: 170,
                    decoration: BoxDecoration(
                      color: FindyColors.primary.withAlpha(60),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: FindyColors.border,
                      ),
                    ),
                    child: Icon(
                      categoryIcon(item.category),
                      size: 72,
                      color: FindyColors.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _claimChip(item.claim),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FindyCard(
                    child: Column(
                      children: [
                        InfoRow('Category', item.category),
                        InfoRow('Date found', fmtDate(item.dateFound)),
                        InfoRow('Location', item.location),
                        InfoRow('Finder', item.finderName),
                        InfoRow('Finder phone', item.finderPhone),
                        InfoRow('Community', item.community),
                        InfoRow('Description', item.description),
                      ],
                    ),
                  ),
                  if (claimed) ...[
                    const SizedBox(height: 12),
                    FindyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Claimed by',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InfoRow('Name', item.claimedBy ?? '-'),
                          InfoRow('Phone', item.claimedByPhone ?? '-'),
                          InfoRow(
                            'Claimed on',
                            item.claimedOn == null
                                ? '-'
                                : fmtDate(item.claimedOn!),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _toggleClaim(context),
                    icon: Icon(
                      claimed ? Icons.undo : Icons.check_circle,
                    ),
                    label: Text(
                      claimed ? 'Mark as unclaimed' : 'Mark as claimed',
                    ),
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

// ---------------- LOST ITEM DETAILS ----------------

class LostItemDetailPage extends StatelessWidget {
  const LostItemDetailPage({
    super.key,
    required this.item,
  });

  final LostItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost item details'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  color: FindyColors.primary.withAlpha(60),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: FindyColors.border,
                  ),
                ),
                child: Icon(
                  categoryIcon(item.category),
                  size: 72,
                  color: FindyColors.accent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const StatusChip('Lost', FindyColors.red),
              const SizedBox(height: 12),
              FindyCard(
                child: Column(
                  children: [
                    InfoRow('Category', item.category),
                    InfoRow('Date lost', fmtDate(item.dateLost)),
                    InfoRow('Location', item.location),
                    InfoRow('Reported by', item.reporterName),
                    InfoRow('Phone', item.reporterPhone),
                    InfoRow('Community', item.community),
                    InfoRow('Description', item.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
