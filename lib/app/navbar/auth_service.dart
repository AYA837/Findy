import 'package:flutter/foundation.dart';

/// The three roles supported by the app.
enum UserRole { user, admin, communityAdmin }

extension UserRoleX on UserRole {
  /// Short key, handy for a future backend / debugging.
  String get key => switch (this) {
    UserRole.user => 'user',
    UserRole.admin => 'admin',
    UserRole.communityAdmin => 'community_admin',
  };

  String get label => switch (this) {
    UserRole.user => 'User',
    UserRole.admin => 'Admin',
    UserRole.communityAdmin => 'Community',
  };
}

/// Mock authentication service (no backend).
///
/// Single shared instance. Anything that listens to it (the navigation shell,
/// the admin pages, the profile switcher) rebuilds when the role changes.
///
/// Change the role from code:   AuthService.instance.setRole(UserRole.admin);
/// Change the default role here: [initialRole].
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// <<< Change this to start the app as another role. >>>
  static const UserRole initialRole = UserRole.user;

  UserRole _role = initialRole;

  UserRole get role => _role;
  bool get isAdmin => _role == UserRole.admin;
  bool get isCommunityAdmin => _role == UserRole.communityAdmin;

  void setRole(UserRole role) {
    if (role == _role) return;
    _role = role;
    notifyListeners();
  }
}
