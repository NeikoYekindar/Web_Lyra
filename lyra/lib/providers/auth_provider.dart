import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_response.dart';
import '../models/signup_response.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  AuthProvider({required String baseUrl}) : _service = AuthService(baseUrl: baseUrl);

  bool _isLoading = false;
  String? _error;
  AuthResponse? _auth;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AuthResponse? get auth => _auth;
  bool get isLoggedIn => _auth != null;
  String get baseUrl => _service.baseUrl;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.login(email: email, password: password);
      _auth = res;
      await _persistTokens(res);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _auth = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    notifyListeners();
  }

  Future<SignupResponse?> signup({
    
    required String displayName,
    required String userType,
    required String fullName,
    required String password,
    required String email,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.signup(
        displayName: displayName,
        userType: userType,
        fullName: fullName,
        password: password,
        email: email,
        dateOfBirth: dateOfBirth,
        gender: gender ?? 'other',
        profileImageUrl: profileImageUrl,
      );
      _isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> _persistTokens(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', auth.accessToken);
    await prefs.setString('refresh_token', auth.refreshToken);
    await prefs.setString('token_type', auth.tokenType);
  }
}
