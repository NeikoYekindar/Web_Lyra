/// API Configuration for microservices
/// Centralized configuration for all backend service endpoints
class ApiConfig {
  // Environment-based base URLs
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // Microservice Base URLs - Configure for your FastAPI services
  static const Map<String, Map<String, String>> _serviceUrls = {
    'dev': {
      'auth': 'http://54.147.43.30:3000',
      'music': 'http://54.147.43.30:3000',
      'user': 'http://54.147.43.30:3000',
      'playlist': 'http://54.147.43.30:3000',
      'search': 'http://54.147.43.30:3000',
    },
    'staging': {
      'auth': 'https://staging-auth.lyra.app',
      'music': 'https://staging-music.lyra.app',
      'user': 'https://staging-user.lyra.app',
      'playlist': 'https://staging-playlist.lyra.app',
      'search': 'https://staging-search.lyra.app',
    },
    'prod': {
      'auth': 'https://auth.lyra.app',
      'music': 'https://music.lyra.app',
      'user': 'https://user.lyra.app',
      'playlist': 'https://playlist.lyra.app',
      'search': 'https://search.lyra.app',
    },
  };

  // Get service URL by name
  static String getServiceUrl(String serviceName) {
    final urls = _serviceUrls[environment];
    if (urls == null || !urls.containsKey(serviceName)) {
      throw Exception(
        'Service URL not configured for: $serviceName in $environment',
      );
    }
    return urls[serviceName]!;
  }

  // API Endpoints for Auth Service
  static String get authServiceUrl => getServiceUrl('auth');
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String verifyTokenEndpoint = '/auths/verify';
  static const String generateTokenEndpoint = '/auths/generate';

  // API Endpoints for Music Service
  static String get musicServiceUrl => getServiceUrl('music');
  static const String topTracks = '/tracks/top-tracks';
  static const String trackDetailEndpoint = '/api/v1/tracks/{id}';
  static const String albumsEndpoint = '/api/v1/albums';
  static const String artistsEndpoint = '/api/v1/artists';
  static const String topArtistsEndpoint = '/artists/top-artists';
  static const String trackStreamsEndpoint = '/tracks/{id}/streams';
  static const String recentTracksEndpoint = '/tracks/recent-tracks';

  // API Endpoints for User Service
  static String get userServiceUrl => getServiceUrl('user');
  static const String loginEndpoint = '/users/login';
  static const String signupEndpoint = '/users/create';
  static const String userUpdateEndpoint = '/users/update';
  // Endpoint used to send OTP for password reset and email verification
  static const String sendOtpEndpoint = '/users/send-otp';
  // Backwards compatibility aliases
  static const String forgotPasswordEndpoint = sendOtpEndpoint;
  static const String sendVerifyEmailEndpoint = sendOtpEndpoint;

  // Upload endpoints
  static const String uploadAvatarEndpoint = '/users/{id}/avatar';
  // Endpoint for initial profile setup (multipart form)
  static const String setUpProfileEndpoint = '/users/set-up';
  static const String verifyOtpEndpoint = '/users/verify-otp';
  static const String resetPasswordEndpoint = '/users/reset-pass';
  static const String logoutEndpoint = '/users/logout';

  // API Endpoints for Playlist Service
  static String get playlistServiceUrl => getServiceUrl('playlist');
  static const String playlistsEndpoint = '/api/v1/playlists';
  static const String playlistDetailEndpoint = '/api/v1/playlists/{id}';
  static const String createPlaylistEndpoint = '/api/v1/playlists';

  // API Endpoints for Search Service
  static String get searchServiceUrl => getServiceUrl('search');
  static const String searchEndpoint = '/api/v1/search';
  static const String suggestionsEndpoint = '/api/v1/search/suggestions';

  // Request Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
