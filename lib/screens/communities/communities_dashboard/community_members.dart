import 'package:flutter/material.dart';

import 'community_home.dart';
import 'mock_data.dart';

// ---------------------------------------------------------------------------
// Members
// ---------------------------------------------------------------------------

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  String _query = '';
  bool _showRequests = false;

  Future<void> _remove(Member m) async {
    final ok = await confirmDialog(
      context,
      title: 'Remove member?',
      message: '${m.name} will be removed from this community.',
      confirmLabel: 'Remove',
    );
    if (ok) AppData.instance.removeMember(m);
  }

  Future<void> _decide(JoinRequest q, {required bool approve}) async {
    final ok = await confirmDialog(
      context,
      title: approve ? 'Approve request?' : 'Reject request?',
      message: approve
          ? '${q.name} will become a member of the community.'
          : '${q.name} will not be able to join with this request.',
      confirmLabel: approve ? 'Approve' : 'Reject',
    );
    if (!ok) return;
    if (approve) {
      AppData.instance.approveRequest(q);
    } else {
      AppData.instance.rejectRequest(q);
    }
  }

  void _openDetails(Member m) {
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
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The phone number is only shown here (details), not in the list,
              // so the admin sees it only when they open a member on purpose.
              InfoRow('Phone', m.phone),
              InfoRow('Joined', fmtDate(m.joined)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: FindyColors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _remove(m);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, bool requests) {
    return ChoiceChip(
      label: Text(label),
      selected: _showRequests == requests,
      selectedColor: FindyColors.primary,
      onSelected: (_) => setState(() => _showRequests = requests),
    );
  }

  Widget _memberList(AppData d) {
    final q = _query.trim().toLowerCase();
    final list = d.members
        .where((m) => q.isEmpty || m.name.toLowerCase().contains(q))
        .toList();
    return Column(
      children: [
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
            hintText: 'Search members',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 16),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No members found',
              style: TextStyle(color: FindyColors.muted),
            ),
          ),
        for (final m in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FindyCard(
              onTap: () => _openDetails(m),
              padding: const EdgeInsets.fromLTRB(16, 12, 6, 12),
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
                        Text(
                          'Joined ${fmtDate(m.joined)}',
                          style: const TextStyle(
                            color: FindyColors.muted,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove member',
                    onPressed: () => _remove(m),
                    icon: const Icon(
                      Icons.person_remove_outlined,
                      color: FindyColors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _requestList(AppData d) {
    return Column(
      children: [
        if (!d.requiresApproval)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'This community is public, so people join instantly. Turn on "Require approval" in Settings to review new requests.',
              style: TextStyle(
                color: FindyColors.muted,
                fontSize: 12.5,
              ),
            ),
          ),
        if (d.requests.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No pending requests',
              style: TextStyle(color: FindyColors.muted),
            ),
          ),
        for (final r in d.requests)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FindyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Avatar(r.name),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Requested ${fmtDate(r.requestedOn)}',
                              style: const TextStyle(
                                color: FindyColors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const StatusChip('Pending', FindyColors.amber),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => _decide(r, approve: false),
                        child: const Text('Reject'),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: () => _decide(r, approve: true),
                        child: const Text('Approve'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, _) {
        final d = AppData.instance;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            PageHeader(
              title: 'Members',
              subtitle: '${d.members.length} in the community',
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tabChip('Members (${d.members.length})', false),
                _tabChip('Requests (${d.requests.length})', true),
              ],
            ),
            const SizedBox(height: 16),
            if (_showRequests) _requestList(d) else _memberList(d),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Settings
// ---------------------------------------------------------------------------

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _d = AppData.instance;
  late final TextEditingController _name = TextEditingController(text: _d.name);
  late final TextEditingController _description =
      TextEditingController(text: _d.description);
  late final TextEditingController _phone =
      TextEditingController(text: _d.phone);
  late final TextEditingController _address =
      TextEditingController(text: _d.address);
  late final TextEditingController _guidelines =
      TextEditingController(text: _d.guidelines);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _phone.dispose();
    _address.dispose();
    _guidelines.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _d.updateInfo(
      newName: _name.text.trim(),
      newDescription: _description.text.trim(),
      newPhone: _phone.text.trim(),
      newAddress: _address.text.trim(),
      newGuidelines: _guidelines.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Community information saved')),
    );
  }

  // The selected photo is now Uint8List data, not a file path.
  Future<void> _choosePhoto() async {
    final photo = await pickPhoto(context);
    if (photo != null) {
      setState(() => _d.setCommunityPhoto(photo));
    }
  }

  Future<void> _delete() async {
    final ok = await confirmDialog(
      context,
      title: 'Delete community?',
      message:
          'This will delete "${_d.name}" and remove all of its members and reports. This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (ok) _d.deleteCommunity();
  }

  @override
  Widget build(BuildContext context) {
    final d = _d;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const PageHeader(title: 'Community settings', subtitle: 'Manage'),
        FindyCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Community photo',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CommunityImage(d.communityPhoto, size: 72),
                    const SizedBox(width: 14),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _choosePhoto,
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 18,
                          ),
                          label: Text(
                            d.communityPhoto == null
                                ? 'Add photo'
                                : 'Change photo',
                          ),
                        ),
                        if (d.communityPhoto != null)
                          TextButton(
                            onPressed: () =>
                                setState(() => d.setCommunityPhoto(null)),
                            child: const Text('Remove'),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Community name',
                  ),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _address,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _guidelines,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Community guidelines',
                    helperText:
                        'What members can post and how they should behave.',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save changes'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FindyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Membership',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Require approval to join'),
                subtitle: Text(
                  d.requiresApproval
                      ? 'Private: you approve or reject each request.'
                      : 'Public: anyone can join instantly.',
                  style: const TextStyle(color: FindyColors.muted),
                ),
                value: d.requiresApproval,
                onChanged: (v) => setState(() => d.setRequiresApproval(v)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FindyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Community status',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  StatusChip(d.status, FindyColors.green),
                ],
              ),
              const SizedBox(height: 6),
              InfoRow('Admin', d.creator),
              InfoRow('Created', fmtDate(d.createdOn)),
              const Text(
                'Approved by Findy Admin. Visible to users and open to join.',
                style: TextStyle(
                  color: FindyColors.muted,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FindyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danger zone',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: FindyColors.red,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Deleting the community removes its members and reports.',
                style: TextStyle(
                  color: FindyColors.muted,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _delete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: FindyColors.red,
                ),
                icon: const Icon(Icons.delete_forever_outlined),
                label: const Text('Delete community'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
