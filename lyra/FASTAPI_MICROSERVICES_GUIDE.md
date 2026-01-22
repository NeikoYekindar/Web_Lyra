# FastAPI Microservices Integration Guide

## 📋 Tổng quan

Project đã được cấu trúc lại để tích hợp với backend FastAPI microservices. Kiến trúc mới bao gồm:

### 🏗️ Cấu trúc thư mục mới

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # Cấu hình endpoints và URLs
│   ├── di/
│   │   └── service_locator.dart     # Dependency injection
│   ├── errors/
│   │   └── api_exceptions.dart      # Custom exceptions
│   ├── models/
│   │   └── api_response.dart        # Generic API response wrappers
│   └── network/
│       └── api_client.dart          # Base HTTP client với interceptors
├── services/
│   ├── auth_service_v2.dart         # Authentication service
│   ├── user_service_v2.dart         # User management service
│   ├── music_service_v2.dart        # Music service (tracks, albums, artists)
│   ├── playlist_service_v2.dart     # Playlist service
│   └── search_service_v2.dart       # Search service
└── providers/
    └── auth_provider_v2.dart        # Updated auth provider
```

## 🚀 Cấu hình Backend URLs

### 1. Chỉnh sửa `lib/core/config/api_config.dart`

```dart
static const Map<String, Map<String, String>> _serviceUrls = {
  'dev': {
    'auth': 'http://localhost:8001',      // Auth microservice
    'music': 'http://localhost:8002',     // Music microservice
    'user': 'http://localhost:8003',      // User microservice
    'playlist': 'http://localhost:8004',  // Playlist microservice
    'search': 'http://localhost:8005',    // Search microservice
  },
  'staging': {
    'auth': 'https://staging-auth.lyra.app',
    // ... other services
  },
  'prod': {
    'auth': 'https://auth.lyra.app',
    // ... other services
  },
};
```

### 2. Chọn environment khi chạy app

```bash
# Development (default)
flutter run -t lib/debug/debug.dart

# Staging
flutter run --dart-define=ENV=staging -t lib/debug/debug.dart

# Production
flutter run --dart-define=ENV=prod -t lib/main.dart
```

## 🔧 Khởi tạo Services

### 1. Cập nhật `main.dart` hoặc `debug.dart`

```dart
import 'package:lyra/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator with all microservices
  await ServiceLocator().initialize();

  // ... existing code
  runApp(const MyApp());
}
```

### 2. Sử dụng AuthProviderV2 thay vì AuthProvider cũ

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProviderV2()),
    ChangeNotifierProvider(create: (_) => MusicPlayerProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => AppShellController()),
  ],
  child: const MyApp(),
)
```

## 📖 Sử dụng Services

### Authentication Service

```dart
import 'package:lyra/core/di/service_locator.dart';

// Login
try {
  final authResponse = await authService.login(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Access Token: ${authResponse.accessToken}');
  print('User: ${authResponse.user.displayName}');
} catch (e) {
  print('Login error: $e');
}

// Signup
try {
  final signupResponse = await authService.signup(
    displayName: 'John Doe',
    userType: 'user',
    fullName: 'John Doe',
    email: 'john@example.com',
    password: 'securepass',
    gender: 'Male',
    dateOfBirth: DateTime(1990, 1, 1),
  );
} catch (e) {
  print('Signup error: $e');
}

// Logout
await authService.logout();
```

### Music Service

```dart
import 'package:lyra/core/di/service_locator.dart';

// Get trending tracks
final tracks = await musicService.getTrendingTracks(limit: 10);

// Get paginated tracks
final paginatedTracks = await musicService.getTracks(
  page: 1,
  pageSize: 20,
  genre: 'pop',
);

// Get track by ID
final track = await musicService.getTrackById('track_123');

// Get popular artists
final artists = await musicService.getPopularArtists(limit: 10);

// Get artist info
final artist = await musicService.getArtistById('artist_456');

// Get artist's tracks
final artistTracks = await musicService.getTracksByArtist('artist_456');
```

### Playlist Service

```dart
import 'package:lyra/core/di/service_locator.dart';

// Get user's playlists
final playlists = await playlistService.getUserPlaylists();

// Create new playlist
final newPlaylist = await playlistService.createPlaylist(
  name: 'My Favorites',
  description: 'My favorite tracks',
  isPublic: true,
);

// Add track to playlist
await playlistService.addTrackToPlaylist(
  'playlist_123',
  'track_456',
);

// Remove track from playlist
await playlistService.removeTrackFromPlaylist(
  'playlist_123',
  'track_456',
);

// Delete playlist
await playlistService.deletePlaylist('playlist_123');
```

### Search Service

```dart
import 'package:lyra/core/di/service_locator.dart';

// Global search
final results = await searchService.search(
  query: 'love songs',
  types: ['track', 'artist', 'album'],
  limit: 20,
);
print('Tracks: ${results.tracks.length}');
print('Artists: ${results.artists.length}');

// Search tracks only
final tracks = await searchService.searchTracks(
  query: 'love',
  limit: 20,
);

// Get search suggestions
final suggestions = await searchService.getSuggestions(
  query: 'lov',
  limit: 10,
);
```

### User Service

```dart
import 'package:lyra/core/di/service_locator.dart';

// Get current user profile
final user = await userService.getCurrentUser();

// Update profile
final updatedUser = await userService.updateCurrentUser(
  displayName: 'New Name',
  bio: 'Music lover',
  favoriteGenres: ['Pop', 'Rock'],
);

// Get favorites
final favorites = await userService.getUserFavorites();

// Add to favorites
await userService.addFavorite('track_123', 'track');

// Remove from favorites
await userService.removeFavorite('track_123');
```

## 🎯 Sử dụng với Provider Pattern

### Trong Widget

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProviderV2>();

    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }

    if (authProvider.error != null) {
      return Text('Error: ${authProvider.error}');
    }

    if (authProvider.isLoggedIn) {
      return Text('Welcome ${authProvider.auth?.user.displayName}');
    }

    return ElevatedButton(
      onPressed: () async {
        await authProvider.login('email@test.com', 'password');
      },
      child: Text('Login'),
    );
  }
}
```

## 🔒 Error Handling

Services tự động xử lý các lỗi phổ biến:

### Exception Types

```dart
try {
  await authService.login(email: email, password: password);
} on AuthException catch (e) {
  // 401, 403 errors
  print('Auth error: ${e.message}');
} on ValidationException catch (e) {
  // 422 validation errors
  print('Validation error: ${e.message}');
  print('Field errors: ${e.errors}');
} on NetworkException catch (e) {
  // Network/connection errors
  print('Network error: ${e.message}');
} on ServerException catch (e) {
  // 500, 503 server errors
  print('Server error: ${e.message}');
} on ApiException catch (e) {
  // Generic API errors
  print('API error: ${e.message}');
}
```

## 🔄 Token Management

API client tự động:

- Thêm Bearer token vào header của mọi request
- Lưu và load tokens từ SharedPreferences
- Xử lý token refresh (cần implement logic trong interceptor nếu cần)

### Manual token management

```dart
// Set tokens
await apiClient.setTokens(accessToken, refreshToken);

// Load saved tokens
await apiClient.loadTokens();

// Clear tokens
await apiClient.clearTokens();

// Check authentication
if (apiClient.isAuthenticated) {
  // User is logged in
}
```

## 📝 Request/Response Logging

Tất cả requests tự động log ra console:

```
🌐 API Request: POST http://localhost:8001/api/v1/auth/login
📤 Body: {"email":"user@test.com","passwd":"***"}
✅ API Success: 200
```

## 🧪 Testing

### Mock services for testing

```dart
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Login test', () async {
    final mockClient = MockClient((request) async {
      return http.Response(
        '{"access_token":"test_token","user":{"user_id":"123"}}',
        200,
      );
    });

    await ServiceLocator().initialize(httpClient: mockClient);

    final response = await authService.login(
      email: 'test@test.com',
      password: 'password',
    );

    expect(response.accessToken, 'test_token');
  });
}
```

## 📋 FastAPI Backend Requirements

Backend của bạn cần implement các endpoints theo format:

### Standard Response Format

```json
{
  "success": true,
  "data": { ... },
  "message": "Success message"
}
```

### Error Response Format

```json
{
  "success": false,
  "message": "Error message",
  "errors": {
    "field_name": ["Error detail 1", "Error detail 2"]
  },
  "status_code": 422
}
```

### Pagination Response Format

```json
{
  "items": [...],
  "page": 1,
  "page_size": 20,
  "total": 100,
  "has_next": true,
  "has_previous": false
}
```

## 🔐 Authentication Flow

1. User login → Nhận access_token và refresh_token
2. Tokens được lưu vào SharedPreferences
3. Mọi request tự động thêm `Authorization: Bearer {access_token}`
4. Khi token hết hạn (401), có thể implement auto-refresh trong interceptor

## 🚨 Migration từ code cũ

### Thay thế imports

```dart
// Cũ
import 'package:lyra/services/auth_service.dart';
import 'package:lyra/providers/auth_provider.dart';

// Mới
import 'package:lyra/services/auth_service_v2.dart';
import 'package:lyra/providers/auth_provider_v2.dart';
import 'package:lyra/core/di/service_locator.dart';
```

### Thay thế Provider creation

```dart
// Cũ
AuthProvider(baseUrl: 'https://example.com')

// Mới
AuthProviderV2()  // Không cần baseUrl, dùng ApiConfig
```

## 📚 Thêm Service mới

Để thêm microservice mới:

1. Thêm URL vào `ApiConfig`:

```dart
static const String notificationServiceUrl = 'http://localhost:8006';
static const String notificationsEndpoint = '/api/v1/notifications';
```

2. Tạo service class:

```dart
class NotificationServiceV2 {
  final ApiClient _apiClient;

  NotificationServiceV2(this._apiClient);

  Future<List<Notification>> getNotifications() async {
    // Implementation
  }
}
```

3. Thêm vào ServiceLocator:

```dart
late final NotificationServiceV2 _notificationService;

void initialize() {
  // ...
  _notificationService = NotificationServiceV2(_apiClient);
}

NotificationServiceV2 get notificationService => _notificationService;
```

## 🎉 Done!

Giờ app của bạn đã sẵn sàng tương tác với FastAPI microservices!
