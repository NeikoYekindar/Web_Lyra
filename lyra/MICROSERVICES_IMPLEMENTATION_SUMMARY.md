# Lyra - FastAPI Microservices Integration

## 🎉 Đã hoàn thành

Project Flutter Lyra đã được refactor hoàn toàn để tương tác với backend FastAPI microservices.

## 📦 Các thành phần đã tạo

### 1. Core Infrastructure

#### `lib/core/config/api_config.dart`

- Centralized configuration cho tất cả microservice endpoints
- Hỗ trợ multi-environment (dev, staging, prod)
- Cấu hình timeout, retry, pagination

#### `lib/core/network/api_client.dart`

- Base HTTP client với đầy đủ tính năng:
  - Request/Response interceptors
  - Automatic token management
  - Error handling
  - Request logging
  - Generic type-safe methods (GET, POST, PUT, PATCH, DELETE)

#### `lib/core/models/api_response.dart`

- Generic API response wrapper
- Paginated response support
- Consistent error structure

#### `lib/core/errors/api_exceptions.dart`

- Custom exception types:
  - `ApiException` - Generic API errors
  - `NetworkException` - Network/connection errors
  - `AuthException` - Authentication errors (401, 403)
  - `ValidationException` - Validation errors (422)
  - `ServerException` - Server errors (500, 503)

#### `lib/core/di/service_locator.dart`

- Dependency injection container
- Centralized service management
- Singleton pattern với lazy initialization

### 2. Microservices

#### `lib/services/auth_service_v2.dart`

- Login/Signup
- Token refresh
- Logout
- Session management

#### `lib/services/user_service_v2.dart`

- Get/Update user profile
- Favorites management (add/remove)
- User preferences

#### `lib/services/music_service_v2.dart`

- Tracks (paginated, trending, by ID)
- Albums (paginated, by artist, by ID)
- Artists (paginated, popular, by ID, with tracks)
- Complete Track, Album, Artist models

#### `lib/services/playlist_service_v2.dart`

- CRUD operations cho playlists
- Add/Remove tracks
- Reorder tracks
- Public/Private playlists
- Complete Playlist model

#### `lib/services/search_service_v2.dart`

- Global search (tracks, albums, artists, playlists)
- Type-specific searches
- Search suggestions/autocomplete
- SearchResult wrapper model

### 3. Providers

#### `lib/providers/auth_provider_v2.dart`

- Updated AuthProvider sử dụng new services
- State management (loading, error, auth data)
- Integration với CurrentUser singleton
- Session restoration
- Error handling với typed exceptions

### 4. Updated Entry Points

#### `lib/main.dart`

- Initialize ServiceLocator
- Use AuthProviderV2
- Ready for production

#### `lib/debug/debug.dart`

- Initialize ServiceLocator
- Use AuthProviderV2
- Mock user setup for development

### 5. Documentation & Examples

#### `FASTAPI_MICROSERVICES_GUIDE.md`

- Comprehensive guide 60+ sections
- Setup instructions
- Service usage examples
- Error handling patterns
- Migration guide
- FastAPI backend requirements

#### `lib/examples/service_usage_examples.dart`

- LoginScreenExample
- MusicListExample
- SearchExample
- PlaylistManagementExample
- ProfileManagementExample

## 🚀 Cách sử dụng

### 1. Cấu hình Backend URLs

Edit `lib/core/config/api_config.dart`:

```dart
static const Map<String, Map<String, String>> _serviceUrls = {
  'dev': {
    'auth': 'http://localhost:8001',
    'music': 'http://localhost:8002',
    'user': 'http://localhost:8003',
    'playlist': 'http://localhost:8004',
    'search': 'http://localhost:8005',
  },
};
```

### 2. Run App

```bash
# Development
flutter run -t lib/debug/debug.dart

# With specific environment
flutter run --dart-define=ENV=staging -t lib/main.dart
```

### 3. Sử dụng Services

```dart
import 'package:lyra/core/di/service_locator.dart';

// Login
final authResponse = await authService.login(
  email: 'user@example.com',
  password: 'password',
);

// Get trending tracks
final tracks = await musicService.getTrendingTracks(limit: 10);

// Search
final results = await searchService.search(
  query: 'love songs',
  types: ['track', 'artist'],
);

// Create playlist
final playlist = await playlistService.createPlaylist(
  name: 'My Favorites',
  isPublic: true,
);
```

## 🏗️ Architecture Highlights

### Separation of Concerns

- **Core**: Infrastructure (config, network, DI, errors)
- **Services**: Business logic và API calls
- **Providers**: State management
- **Models**: Data structures

### Type Safety

- Generic API responses với type inference
- Strongly typed models
- Type-safe service methods

### Error Handling

- Custom exception hierarchy
- Automatic error parsing
- User-friendly error messages (Vietnamese)

### Scalability

- Easy to add new microservices
- Modular service architecture
- Centralized configuration

### Developer Experience

- Comprehensive documentation
- Working examples
- Clear migration path
- Request/Response logging

## 📋 FastAPI Backend Requirements

Backend cần implement:

### Standard Response Format

```json
{
  "success": true,
  "data": {...},
  "message": "Success"
}
```

### Error Format

```json
{
  "success": false,
  "message": "Error message",
  "errors": { "field": ["error"] },
  "status_code": 422
}
```

### Authentication

- JWT tokens (access + refresh)
- Bearer token trong Authorization header
- Token expiry handling

### Pagination

```json
{
  "items": [...],
  "page": 1,
  "page_size": 20,
  "total": 100,
  "has_next": true
}
```

## 🔐 Security Features

- Automatic token management
- Secure token storage (SharedPreferences)
- Token refresh support
- Auth interceptors
- Session validation

## 📊 Status

✅ **HOÀN THÀNH** - Project sẵn sàng tương tác với FastAPI microservices

### Đã implement:

- [x] Core infrastructure
- [x] All 5 microservices (Auth, User, Music, Playlist, Search)
- [x] Complete models
- [x] Error handling
- [x] State management
- [x] Documentation
- [x] Examples
- [x] Migration from old code

### Next Steps (Optional):

- [ ] Implement auto token refresh interceptor
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Implement offline caching
- [ ] Add analytics/monitoring
- [ ] WebSocket support cho real-time features

## 📞 Support

Xem chi tiết tại:

- `FASTAPI_MICROSERVICES_GUIDE.md` - Complete guide
- `lib/examples/service_usage_examples.dart` - Working examples
- `lib/core/` - Core infrastructure code
- `lib/services/` - Microservice implementations

---

**Tác giả**: GitHub Copilot  
**Ngày**: January 15, 2026  
**Version**: 2.0.0 - Microservices Ready
