import 'package:http/http.dart' as http;
import '../network/api_client.dart';
import '../../services/auth_service_v2.dart';
import '../../services/user_service_v2.dart';
import '../../services/music_service_v2.dart';
import '../../services/playlist_service_v2.dart';
import '../../services/search_service_v2.dart';

/// Service locator for dependency injection
/// Centralized access to all services and API client
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core services
  late final ApiClient _apiClient;

  // Domain services
  late final AuthServiceV2 _authService;
  late final UserServiceV2 _userService;
  late final MusicServiceV2 _musicService;
  late final PlaylistServiceV2 _playlistService;
  late final SearchServiceV2 _searchService;

  bool _isInitialized = false;

  /// Initialize all services
  Future<void> initialize({http.Client? httpClient}) async {
    if (_isInitialized) {
      return;
    }

    // Initialize API client
    _apiClient = ApiClient(httpClient: httpClient);

    // Load saved tokens if any
    await _apiClient.loadTokens();

    // Initialize services
    _authService = AuthServiceV2(_apiClient);
    _userService = UserServiceV2(_apiClient);
    _musicService = MusicServiceV2(_apiClient);
    _playlistService = PlaylistServiceV2(_apiClient);
    _searchService = SearchServiceV2(_apiClient);

    _isInitialized = true;
  }

  /// Get API client
  ApiClient get apiClient {
    _ensureInitialized();
    return _apiClient;
  }

  /// Get auth service
  AuthServiceV2 get authService {
    _ensureInitialized();
    return _authService;
  }

  /// Get user service
  UserServiceV2 get userService {
    _ensureInitialized();
    return _userService;
  }

  /// Get music service
  MusicServiceV2 get musicService {
    _ensureInitialized();
    return _musicService;
  }

  /// Get playlist service
  PlaylistServiceV2 get playlistService {
    _ensureInitialized();
    return _playlistService;
  }

  /// Get search service
  SearchServiceV2 get searchService {
    _ensureInitialized();
    return _searchService;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'ServiceLocator not initialized. Call initialize() first.',
      );
    }
  }

  /// Dispose all services
  void dispose() {
    if (_isInitialized) {
      _apiClient.dispose();
      _isInitialized = false;
    }
  }

  /// Reset singleton (useful for testing)
  void reset() {
    dispose();
    _isInitialized = false;
  }
}

/// Convenience getters for services
final serviceLocator = ServiceLocator();
ApiClient get apiClient => serviceLocator.apiClient;
AuthServiceV2 get authService => serviceLocator.authService;
UserServiceV2 get userService => serviceLocator.userService;
MusicServiceV2 get musicService => serviceLocator.musicService;
PlaylistServiceV2 get playlistService => serviceLocator.playlistService;
SearchServiceV2 get searchService => serviceLocator.searchService;
