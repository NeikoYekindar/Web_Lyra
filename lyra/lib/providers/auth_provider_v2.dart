import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../core/di/service_locator.dart';
import '../core/errors/api_exceptions.dart';
import '../models/auth_response.dart';
import '../models/signup_response.dart';
import '../models/current_user.dart';
import '../models/user.dart';
import '../services/interaction_service.dart';

/// Updated AuthProvider using microservice architecture
class AuthProviderV2 extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  AuthResponse? _auth;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AuthResponse? get auth => _auth;
  bool get isLoggedIn => _auth != null && authService.isAuthenticated;

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.login(
        email: email,
        password: password,
      );

      _auth = response;

      // If user data is not in login response, fetch it
      UserModel? user = response.user;
      if (user == null) {
        try {
          user = await userService.getCurrentUser();
        } catch (e) {
          print('Failed to fetch user after login: $e');
        }
      }

      // Update CurrentUser singleton if we have user data
      if (user != null) {
        print('👤 User data from login:');
        print('  - Display Name: ${user.displayName}');
        print('  - Email: ${user.email}');
        print('  - Profile Image URL: ${user.profileImageUrl}');
        CurrentUser.instance.login(user);
        await CurrentUser.instance.saveToPrefs();
      }

      // Debug: Verify tokens are saved
      print('✅ Login successful');
      print(
        'Access token saved: ${apiClient.accessToken?.substring(0, 20)}...',
      );
      print(
        'Refresh token saved: ${apiClient.refreshToken?.substring(0, 20)}...',
      );

      // Trigger recommendation model retrain and reload after login (non-blocking)
      InteractionService.triggerRetrain().then((_) {
        InteractionService.reloadModels();
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on NetworkException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } on ValidationException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Lỗi không xác định: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Signup new user
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
      final response = await authService.signup(
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

      // If signup endpoint already returned tokens and they were saved in ApiClient,
      // we don't need to call login() again. Otherwise perform auto-login.
      if (apiClient.accessToken == null || apiClient.accessToken!.isEmpty) {
        final loggedIn = await login(email, password);
        if (!loggedIn) {
          // Auto-login failed; still return the signup response
          return response;
        }
      }

      // At this point tokens and CurrentUser should be persisted by login()
      return response;
    } on ValidationException catch (e) {
      _isLoading = false;
      _error = e.message;

      // Format validation errors for display
      if (e.errors != null) {
        final errorMessages = <String>[];
        e.errors!.forEach((field, messages) {
          if (messages is List) {
            errorMessages.addAll(messages.map((m) => '$field: $m'));
          } else {
            errorMessages.add('$field: $messages');
          }
        });
        _error = errorMessages.join('\n');
      }

      notifyListeners();
      return null;
    } on NetworkException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      _error = 'Lỗi không xác định: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  /// Refresh token
  Future<bool> refreshToken() async {
    try {
      final response = await authService.refreshToken();
      _auth = response;

      // Fetch current user after refresh if not included in response
      UserModel? user = response.user;
      if (user == null) {
        try {
          user = await userService.getCurrentUser();
        } catch (e) {
          print('Failed to fetch user after token refresh: $e');
        }
      }

      // Update CurrentUser if we have user data
      if (user != null) {
        CurrentUser.instance.login(user);
        await CurrentUser.instance.saveToPrefs();
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to refresh token: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await authService.logout();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _auth = null;
      _error = null;

      // Clear CurrentUser
      CurrentUser.instance.logout();
      await CurrentUser.instance.clearPrefs();

      notifyListeners();
    }
  }

  /// Check and restore session on app start
  Future<void> restoreSession() async {
    print('🔄 Attempting to restore session...');
    print('Has access token: ${apiClient.accessToken != null}');
    print('Has refresh token: ${apiClient.refreshToken != null}');
    print('Has cached user: ${CurrentUser.instance.user != null}');

    if (authService.isAuthenticated) {
      // Check if we have cached user data
      final cachedUser = CurrentUser.instance.user;

      if (cachedUser == null) {
        print('❌ No cached user data, user needs to login');
        await logout();
        return;
      }

      // Verify token with server to ensure it's still valid
      try {
        print('🔐 Verifying token with server...');
        final isValid = await authService.verifyToken();

        if (!isValid) {
          print('❌ Token is invalid or expired');
          await logout();
          return;
        }

        // Token is valid, restore session with cached user data
        _auth = AuthResponse(
          tokenType: 'Bearer',
          accessToken: apiClient.accessToken ?? '',
          refreshToken: apiClient.refreshToken ?? '',
          expiresIn: '',
          user: cachedUser,
        );

        print('✅ Session restored successfully');
      } catch (e) {
        print('❌ Token verification failed: $e');
        await logout();
        return;
      }

      // Use addPostFrameCallback to notify after build phase
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } else {
      print('❌ No valid tokens found, user needs to login');
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
