import 'package:flutter/foundation.dart';
import 'user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple singleton to hold the currently authenticated user's data.
///
/// Usage:
/// ```dart
/// CurrentUser.instance.login(userModel);
/// CurrentUser.instance.user; // current user or null
/// CurrentUser.instance.userNotifier.addListener(() { ... });
/// ```
class CurrentUser {
  CurrentUser._internal();
  static final CurrentUser instance = CurrentUser._internal();

  UserModel? _user;
  final ValueNotifier<UserModel?> userNotifier = ValueNotifier(null);

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  void login(UserModel userModel) {
    _user = userModel;
    userNotifier.value = _user;
  }

  void logout() {
    _user = null;
    userNotifier.value = null;
  }

  /// Update the current user fields partially and notify listeners.
  void update(UserModel Function(UserModel) updater) {
    if (_user == null) return;
    _user = updater(_user!);
    userNotifier.value = _user;
  }

  /// Persist the current user snapshot into shared preferences.
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user == null) {
      await prefs.remove('current_user');
      return;
    }
    final jsonStr = jsonEncode(_user!.toJson());
    await prefs.setString('current_user', jsonStr);
  }

  /// Restore the current user from shared preferences if present.
  Future<void> restoreFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('current_user');
    if (jsonStr == null) return;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final userModel = UserModel.fromJson(map);
      _user = userModel;
      userNotifier.value = _user;
    } catch (_) {
      // ignore parse errors
    }
  }
}
