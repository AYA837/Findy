import 'dart:typed_data';

import 'package:flutter/material.dart';

enum ReportType { lost, found }

/// open -> (member says it was returned) pendingReview -> resolved
enum ReportStatus { open, pendingReview, resolved }

class Report {
  Report({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.date,
    required this.location,
    required this.reporter,
    required this.description,
    this.status = ReportStatus.open,
    this.pinned = false,
    this.photoPath,
    this.returnReportedBy,
    this.returnNote,
  });

  final String id;
  final String name;
  final String category;
  final ReportType type;
  final DateTime date;
  final String location;
  final String reporter;
  final String description;
  ReportStatus status;
  bool pinned;

  /// Stores the image bytes (works on Flutter Web and mobile).
  Uint8List? photoPath;

  /// A member reported that the item was returned (waiting for admin review).
  String? returnReportedBy;
  String? returnNote;

  /// Filled by the community admin when the item is resolved / returned.
  String? resolvedBy;
  String? resolvedByPhone;
  DateTime? resolvedOn;
}

class Member {
  const Member({
    required this.id,
    required this.name,
    required this.phone,
    required this.joined,
  });

  final String id;
  final String name;
  final String phone;
  final DateTime joined;
}

class JoinRequest {
  const JoinRequest({
    required this.id,
    required this.name,
    required this.phone,
    required this.requestedOn,
  });

  final String id;
  final String name;
  final String phone;
  final DateTime requestedOn;
}

class Activity {
  const Activity(this.icon, this.text, this.date);

  final IconData icon;
  final String text;
  final DateTime date;
}

/// Single in-memory store for the (mock, already approved) community.
class AppData extends ChangeNotifier {
  AppData._() {
    _seed();
  }

  static final AppData instance = AppData._();

  // Community info
  late String name;
  late String description;
  late String phone;
  late String address;
  late String guidelines;
  late bool requiresApproval;

  // Store the community image as bytes.
  Uint8List? communityPhoto;

  late String status;
  late String creator;
  late DateTime createdOn;
  late bool deleted;

  late List<Report> reports;
  late List<Member> members;
  late List<JoinRequest> requests;
  late List<Activity> activity;

  void _seed() {
    name = 'University Campus';
    description =
        'Lost and found for students and staff of the campus. Report what you lose, return what you find.';
    phone = '+213 555 20 30 40';
    address = 'University Campus, Block A, Main Entrance';
    guidelines = '1. Only post real lost or found items.\n'
        '2. No spam, ads or personal attacks.\n'
        '3. Do not share private documents or ID numbers in photos.\n'
        '4. Mark your report as returned once the item is handed over.';

    requiresApproval = true;
    communityPhoto = null;
    status = 'Approved';
    creator = 'Amine Belkacem';
    createdOn = DateTime(2026, 9, 2);
    deleted = false;

    reports = [
      Report(
        id: 'r1',
        name: 'Black leather wallet',
        category: 'Wallets',
        type: ReportType.lost,
        date: DateTime(2026, 11, 26),
        location: 'Library - 2nd floor',
        reporter: 'Lina Bouzid',
        description: 'Contains a student card and some cash.',
        pinned: true,
      ),
      Report(
        id: 'r2',
        name: 'Grey backpack',
        category: 'Bags',
        type: ReportType.found,
        date: DateTime(2026, 11, 25),
        location: 'Block C - Room 14',
        reporter: 'Sara Haddad',
        description: 'Notebooks and a water bottle inside.',
      ),
      Report(
        id: 'r3',
        name: 'iPhone 14 (blue case)',
        category: 'Technology',
        type: ReportType.lost,
        date: DateTime(2026, 11, 24),
        location: 'Cafeteria',
        reporter: 'Karim Djaballah',
        description: 'Cracked corner on the case.',
        status: ReportStatus.pendingReview,
        returnReportedBy: 'Karim Djaballah',
        returnNote:
            'A student brought it to the cafeteria desk, I have it back.',
      ),
      Report(
        id: 'r4',
        name: 'Set of 3 keys',
        category: 'Keys',
        type: ReportType.found,
        date: DateTime(2026, 11, 23),
        location: 'Main entrance',
        reporter: 'Yacine Merah',
        description: 'Silver keys on a red ring.',
        status: ReportStatus.resolved,
      )
        ..resolvedBy = 'Omar Cherif'
        ..resolvedByPhone = '+213 555 16 17 18'
        ..resolvedOn = DateTime(2026, 11, 24),
      Report(
        id: 'r5',
        name: 'Calculus textbook',
        category: 'Books',
        type: ReportType.lost,
        date: DateTime(2026, 11, 21),
        location: 'Lecture hall A',
        reporter: 'Amine Belkacem',
        description: 'Name written on the first page.',
        status: ReportStatus.resolved,
      )
        ..resolvedBy = 'Amine Belkacem'
        ..resolvedOn = DateTime(2026, 11, 22),
      Report(
        id: 'r6',
        name: 'Wireless earbuds',
        category: 'Electronics',
        type: ReportType.found,
        date: DateTime(2026, 11, 20),
        location: 'Sports hall',
        reporter: 'Lina Bouzid',
        description: 'White charging case, one earbud inside.',
        status: ReportStatus.pendingReview,
        returnReportedBy: 'Omar Cherif',
        returnNote: 'I picked them up from Lina at the sports hall.',
      ),
      Report(
        id: 'r7',
        name: 'Win a free phone!!! click here',
        category: 'Other',
        type: ReportType.found,
        date: DateTime(2026, 11, 19),
        location: 'Unknown',
        reporter: 'Unknown user',
        description: 'Looks like a spam report.',
      ),
    ];

    members = [
      Member(
        id: 'm1',
        name: 'Amine Belkacem',
        phone: '+213 555 04 05 06',
        joined: DateTime(2026, 9, 2),
      ),
      Member(
        id: 'm2',
        name: 'Sara Haddad',
        phone: '+213 555 01 02 03',
        joined: DateTime(2026, 9, 10),
      ),
      Member(
        id: 'm3',
        name: 'Yacine Merah',
        phone: '+213 555 07 08 09',
        joined: DateTime(2026, 9, 28),
      ),
      Member(
        id: 'm4',
        name: 'Lina Bouzid',
        phone: '+213 555 10 11 12',
        joined: DateTime(2026, 10, 5),
      ),
      Member(
        id: 'm5',
        name: 'Karim Djaballah',
        phone: '+213 555 13 14 15',
        joined: DateTime(2026, 10, 19),
      ),
      Member(
        id: 'm6',
        name: 'Omar Cherif',
        phone: '+213 555 16 17 18',
        joined: DateTime(2026, 11, 8),
      ),
    ];

    requests = [
      JoinRequest(
        id: 'q1',
        name: 'Nadia Ferhat',
        phone: '+213 555 21 22 23',
        requestedOn: DateTime(2026, 11, 25),
      ),
      JoinRequest(
        id: 'q2',
        name: 'Walid Benali',
        phone: '+213 555 24 25 26',
        requestedOn: DateTime(2026, 11, 26),
      ),
      JoinRequest(
        id: 'q3',
        name: 'Ines Mansouri',
        phone: '+213 555 27 28 29',
        requestedOn: DateTime(2026, 11, 27),
      ),
    ];

    activity = [
      Activity(
        Icons.campaign,
        'Announcement: Lost & found desk is open 9-17',
        DateTime(2026, 11, 26),
      ),
      Activity(
        Icons.check_circle,
        'Set of 3 keys marked as returned',
        DateTime(2026, 11, 24),
      ),
      Activity(
        Icons.person_add,
        'Omar Cherif joined the community',
        DateTime(2026, 11, 8),
      ),
      Activity(
        Icons.verified,
        'Community approved by Findy Admin',
        DateTime(2026, 9, 3),
      ),
    ];
  }

  // ---- Derived --------------------------------------------------------

  int get lostCount => reports.where((r) => r.type == ReportType.lost).length;

  int get foundCount => reports.where((r) => r.type == ReportType.found).length;

  /// Pinned reports first, then newest first.
  List<Report> get sortedReports {
    final list = [...reports];

    list.sort((a, b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }

      return b.date.compareTo(a.date);
    });

    return list;
  }

  // ---- Actions --------------------------------------------------------

  void _log(IconData icon, String text) {
    activity.insert(0, Activity(icon, text, DateTime.now()));
  }

  void updateInfo({
    required String newName,
    required String newDescription,
    required String newPhone,
    required String newAddress,
    required String newGuidelines,
  }) {
    name = newName;
    description = newDescription;
    phone = newPhone;
    address = newAddress;
    guidelines = newGuidelines;

    _log(Icons.edit, 'Community information updated');
    notifyListeners();
  }

  // Save community image bytes.
  void setCommunityPhoto(Uint8List? photo) {
    communityPhoto = photo;
    notifyListeners();
  }

  void setRequiresApproval(bool value) {
    requiresApproval = value;

    _log(
      Icons.lock_outline,
      value ? 'Joining now requires approval' : 'Community is now public',
    );

    notifyListeners();
  }

  // Save report image bytes.
  void setReportPhoto(Report r, Uint8List photo) {
    r.photoPath = photo;
    notifyListeners();
  }

  void togglePin(Report r) {
    r.pinned = !r.pinned;

    _log(
      Icons.push_pin,
      '${r.name} ${r.pinned ? 'pinned' : 'unpinned'}',
    );

    notifyListeners();
  }

  /// Resolve / return an item and record who took it, their phone and when.
  void resolveReport(
    Report r,
    String by,
    String byPhone,
    DateTime on,
  ) {
    r.status = ReportStatus.resolved;
    r.resolvedBy = by;
    r.resolvedByPhone = byPhone.isEmpty ? null : byPhone;
    r.resolvedOn = on;

    _log(
      Icons.check_circle,
      '${r.name} marked as ${r.type == ReportType.found ? 'returned' : 'resolved'} ($by)',
    );

    notifyListeners();
  }

  /// Admin disagrees with a member's "it was returned" report.
  void rejectReturnReport(Report r) {
    r.status = ReportStatus.open;
    r.returnReportedBy = null;
    r.returnNote = null;

    _log(Icons.report_off, 'Return report rejected for ${r.name}');

    notifyListeners();
  }

  void removeReport(Report r) {
    reports.remove(r);

    _log(Icons.delete_outline, 'Report removed: ${r.name}');

    notifyListeners();
  }

  void removeMember(Member m) {
    members.remove(m);

    _log(Icons.person_remove, '${m.name} was removed from the community');

    notifyListeners();
  }

  void approveRequest(JoinRequest q) {
    requests.remove(q);

    members.add(
      Member(
        id: 'm${DateTime.now().microsecondsSinceEpoch}',
        name: q.name,
        phone: q.phone,
        joined: DateTime.now(),
      ),
    );

    _log(Icons.person_add, '${q.name} joined the community');

    notifyListeners();
  }

  void rejectRequest(JoinRequest q) {
    requests.remove(q);

    _log(Icons.person_off, 'Join request from ${q.name} rejected');

    notifyListeners();
  }

  void postAnnouncement(String text) {
    _log(Icons.campaign, 'Announcement: $text');

    notifyListeners();
  }

  void deleteCommunity() {
    deleted = true;
    notifyListeners();
  }

  /// Brings the mock community back (testing only).
  void reset() {
    _seed();
    notifyListeners();
  }
}
