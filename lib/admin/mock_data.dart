import 'package:flutter/foundation.dart';

enum ClaimStatus { unclaimed, claimed }

enum RequestStatus { pending, accepted, rejected }

class FoundItem {
  FoundItem({
    required this.id,
    required this.name,
    required this.category,
    required this.dateFound,
    required this.location,
    required this.finderName,
    required this.finderPhone,
    required this.community,
    required this.description,
    this.claim = ClaimStatus.unclaimed,
    this.claimedBy,
    this.claimedByPhone,
    this.claimedOn,
  });

  final String id;
  final String name;
  String category;
  final DateTime dateFound;
  final String location;
  final String finderName;
  final String finderPhone;
  final String community;
  final String description;

  ClaimStatus claim;
  String? claimedBy;
  String? claimedByPhone;
  DateTime? claimedOn;
}

class LostItem {
  LostItem({
    required this.id,
    required this.name,
    required this.category,
    required this.dateLost,
    required this.location,
    required this.reporterName,
    required this.reporterPhone,
    required this.community,
    required this.description,
  });

  final String id;
  final String name;
  String category;
  final DateTime dateLost;
  final String location;
  final String reporterName;
  final String reporterPhone;
  final String community;
  final String description;
}

class Community {
  Community({
    required this.id,
    required this.name,
    required this.creator,
    required this.description,
    required this.requestDate,
    this.status = RequestStatus.pending,
  });

  final String id;
  final String name;
  final String creator;
  final String description;
  final DateTime requestDate;
  RequestStatus status;
}

class Member {
  const Member({
    required this.id,
    required this.name,
    required this.phone,
    required this.registered,
    required this.communities,
  });

  final String id;
  final String name;
  final String phone;
  final DateTime registered;
  final List<String> communities;
}

/// Single in-memory store. Widgets listen to it and rebuild on changes.
class AppData extends ChangeNotifier {
  AppData._();

  static final AppData instance = AppData._();

  final List<String> categories = [
    'Technology',
    'Electronics',
    'Clothes',
    'Books',
    'Wallets',
    'Keys',
    'Accessories',
    'Documents',
    'Bags',
    'Jewelry',
    'Other',
  ];

  // ---------------- FOUND ITEMS ----------------

  final List<FoundItem> items = [
    FoundItem(
      id: 'i1',
      name: 'iPhone 14 (blue case)',
      category: 'Technology',
      dateFound: DateTime(2026, 11, 22),
      location: 'Central Metro Station',
      finderName: 'Sara Haddad',
      finderPhone: '+213 555 01 02 03',
      community: 'Central Metro Station',
      description: 'Found on a bench near platform 2. Screen is locked.',
    ),
    FoundItem(
      id: 'i2',
      name: 'Black leather wallet',
      category: 'Wallets',
      dateFound: DateTime(2026, 11, 21),
      location: 'University Campus - Library',
      finderName: 'Amine Belkacem',
      finderPhone: '+213 555 04 05 06',
      community: 'University Campus',
      description: 'Contains a student card and some cash.',
      claim: ClaimStatus.claimed,
      claimedBy: 'Lina Bouzid',
      claimedByPhone: '+213 555 10 11 12',
      claimedOn: DateTime(2026, 11, 22),
    ),
    FoundItem(
      id: 'i3',
      name: 'Set of 3 keys',
      category: 'Keys',
      dateFound: DateTime(2026, 11, 20),
      location: 'Grand Mall - Entrance B',
      finderName: 'Yacine Merah',
      finderPhone: '+213 555 07 08 09',
      community: 'Grand Mall',
      description: 'Silver keys on a red ring with a small tag.',
    ),
    FoundItem(
      id: 'i4',
      name: 'Grey backpack',
      category: 'Bags',
      dateFound: DateTime(2026, 11, 19),
      location: 'University Campus - Block C',
      finderName: 'Lina Bouzid',
      finderPhone: '+213 555 10 11 12',
      community: 'University Campus',
      description: 'Contains notebooks and a water bottle.',
    ),
    FoundItem(
      id: 'i5',
      name: 'Wireless earbuds',
      category: 'Electronics',
      dateFound: DateTime(2026, 11, 17),
      location: 'Downtown Library',
      finderName: 'Karim Djaballah',
      finderPhone: '+213 555 13 14 15',
      community: 'Downtown Library',
      description: 'White charging case, one earbud inside.',
      claim: ClaimStatus.claimed,
      claimedBy: 'Omar Cherif',
      claimedByPhone: '+213 555 16 17 18',
      claimedOn: DateTime(2026, 11, 18),
    ),
    FoundItem(
      id: 'i6',
      name: 'Passport holder',
      category: 'Documents',
      dateFound: DateTime(2026, 11, 15),
      location: 'Central Metro Station',
      finderName: 'Sara Haddad',
      finderPhone: '+213 555 01 02 03',
      community: 'Central Metro Station',
      description: 'Brown holder with documents inside.',
    ),
  ];

  // ---------------- LOST ITEMS ----------------

  final List<LostItem> lostItems = [
    LostItem(
      id: 'l1',
      name: 'Samsung Galaxy S24',
      category: 'Technology',
      dateLost: DateTime(2026, 11, 23),
      location: 'University Campus - Block A',
      reporterName: 'Nadia Benali',
      reporterPhone: '+213 555 20 21 22',
      community: 'University Campus',
      description: 'Black phone with a transparent case.',
    ),
    LostItem(
      id: 'l2',
      name: 'Student ID Card',
      category: 'Documents',
      dateLost: DateTime(2026, 11, 22),
      location: 'Central Metro Station',
      reporterName: 'Mehdi Amrani',
      reporterPhone: '+213 555 23 24 25',
      community: 'Central Metro Station',
      description: 'Student ID card with a blue cover.',
    ),
    LostItem(
      id: 'l3',
      name: 'Brown leather handbag',
      category: 'Bags',
      dateLost: DateTime(2026, 11, 21),
      location: 'Grand Mall - Food Court',
      reporterName: 'Yasmine Kaci',
      reporterPhone: '+213 555 26 27 28',
      community: 'Grand Mall',
      description: 'Small brown handbag with personal belongings.',
    ),
    LostItem(
      id: 'l4',
      name: 'Silver bracelet',
      category: 'Jewelry',
      dateLost: DateTime(2026, 11, 20),
      location: 'Downtown Library',
      reporterName: 'Rania Saidi',
      reporterPhone: '+213 555 29 30 31',
      community: 'Downtown Library',
      description: 'Thin silver bracelet with a small heart.',
    ),
    LostItem(
      id: 'l5',
      name: 'Black headphones',
      category: 'Electronics',
      dateLost: DateTime(2026, 11, 19),
      location: 'University Campus - Library',
      reporterName: 'Amine Boudiaf',
      reporterPhone: '+213 555 32 33 34',
      community: 'University Campus',
      description: 'Wireless black headphones in a black case.',
    ),
  ];

  // ---------------- COMMUNITIES ----------------

  final List<Community> communities = [
    Community(
      id: 'c1',
      name: 'University Campus',
      creator: 'Amine Belkacem',
      description: 'Lost and found for students and staff of the campus.',
      requestDate: DateTime(2026, 9, 2),
      status: RequestStatus.accepted,
    ),
    Community(
      id: 'c2',
      name: 'Central Metro Station',
      creator: 'Sara Haddad',
      description: 'Items lost in the metro station and nearby lines.',
      requestDate: DateTime(2026, 9, 14),
      status: RequestStatus.accepted,
    ),
    Community(
      id: 'c3',
      name: 'Grand Mall',
      creator: 'Yacine Merah',
      description: 'Shoppers and shop owners sharing found items.',
      requestDate: DateTime(2026, 10, 1),
      status: RequestStatus.accepted,
    ),
    Community(
      id: 'c4',
      name: 'Downtown Library',
      creator: 'Karim Djaballah',
      description: 'Readers and librarians returning forgotten belongings.',
      requestDate: DateTime(2026, 11, 18),
    ),
    Community(
      id: 'c5',
      name: 'Riverside Park Club',
      creator: 'Lina Bouzid',
      description: 'Joggers and families who use the riverside park.',
      requestDate: DateTime(2026, 11, 20),
    ),
    Community(
      id: 'c6',
      name: 'Old Town Market',
      creator: 'Omar Cherif',
      description: 'Market vendors and visitors.',
      requestDate: DateTime(2026, 11, 21),
    ),
    Community(
      id: 'c7',
      name: 'Night Taxi Group',
      creator: 'Nadir Slimani',
      description: 'Request with an incomplete description.',
      requestDate: DateTime(2026, 10, 25),
      status: RequestStatus.rejected,
    ),
  ];

  // ---------------- MEMBERS ----------------

  final List<Member> members = [
    Member(
      id: 'm1',
      name: 'Amine Belkacem',
      phone: '+213 555 04 05 06',
      registered: DateTime(2026, 8, 30),
      communities: ['University Campus', 'Grand Mall'],
    ),
    Member(
      id: 'm2',
      name: 'Sara Haddad',
      phone: '+213 555 01 02 03',
      registered: DateTime(2026, 9, 10),
      communities: ['Central Metro Station'],
    ),
    Member(
      id: 'm3',
      name: 'Yacine Merah',
      phone: '+213 555 07 08 09',
      registered: DateTime(2026, 9, 28),
      communities: ['Grand Mall'],
    ),
    Member(
      id: 'm4',
      name: 'Lina Bouzid',
      phone: '+213 555 10 11 12',
      registered: DateTime(2026, 10, 5),
      communities: ['University Campus', 'Central Metro Station'],
    ),
    Member(
      id: 'm5',
      name: 'Karim Djaballah',
      phone: '+213 555 13 14 15',
      registered: DateTime(2026, 10, 19),
      communities: ['Downtown Library'],
    ),
  ];

  // ---------------- DERIVED COUNTS ----------------

  int get lostItemsCount => lostItems.length;

  int get foundItemsCount => items.length;

  int get totalItemsCount => items.length + lostItems.length;

  int get acceptedCommunities =>
      communities.where((c) => c.status == RequestStatus.accepted).length;

  List<Community> get pendingRequests =>
      communities.where((c) => c.status == RequestStatus.pending).toList();

  // ---------------- ACTIONS ----------------

  void addCategory(String name) {
    categories.add(name);
    notifyListeners();
  }

  void renameCategory(String oldName, String newName) {
    final i = categories.indexOf(oldName);
    if (i == -1) return;

    categories[i] = newName;

    for (final item in items) {
      if (item.category == oldName) {
        item.category = newName;
      }
    }

    for (final item in lostItems) {
      if (item.category == oldName) {
        item.category = newName;
      }
    }

    notifyListeners();
  }

  void deleteCategory(String name) {
    categories.remove(name);
    notifyListeners();
  }

  void setCommunityStatus(Community c, RequestStatus status) {
    c.status = status;
    notifyListeners();
  }

  void claimItem(
    FoundItem item,
    String by,
    String phone,
    DateTime claimedOn,
  ) {
    item.claim = ClaimStatus.claimed;
    item.claimedBy = by;
    item.claimedByPhone = phone.isEmpty ? null : phone;
    item.claimedOn = claimedOn;

    notifyListeners();
  }

  void unclaimItem(FoundItem item) {
    item.claim = ClaimStatus.unclaimed;
    item.claimedBy = null;
    item.claimedByPhone = null;
    item.claimedOn = null;

    notifyListeners();
  }
}
