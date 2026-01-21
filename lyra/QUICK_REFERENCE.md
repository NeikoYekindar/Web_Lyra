# 🚀 Quick Reference - Lyra Microservices API

## Setup (trong main.dart hoặc debug.dart)

```dart
import 'package:lyra/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator().initialize();  // ← BẮT BUỘC
  runApp(const MyApp());
}
```

## Import Services

```dart
import 'package:lyra/core/di/service_locator.dart';

// Sau đó dùng trực tiếp:
authService.login(...)
musicService.getTracks(...)
playlistService.createPlaylist(...)
searchService.search(...)
userService.getCurrentUser()
```

## 🔐 Authentication

```dart
// Login
final auth = await authService.login(
  email: 'user@test.com',
  password: 'pass123'
);

// Signup
final signup = await authService.signup(
  displayName: 'John',
  userType: 'user',
  fullName: 'John Doe',
  email: 'john@test.com',
  password: 'pass123',
  gender: 'Male',
);

// Logout
await authService.logout();

// Check if logged in
if (authService.isAuthenticated) { ... }
```

## 🎵 Music Service

```dart
// Trending tracks
final tracks = await musicService.getTrendingTracks(limit: 10);

// Paginated tracks
final paginated = await musicService.getTracks(
  page: 1,
  pageSize: 20,
  genre: 'pop'
);

// Track by ID
final track = await musicService.getTrackById('track_123');

// Popular artists
final artists = await musicService.getPopularArtists(limit: 10);

// Artist by ID
final artist = await musicService.getArtistById('artist_456');

// Artist's tracks
final artistTracks = await musicService.getTracksByArtist('artist_456');

// Albums
final albums = await musicService.getAlbums(page: 1, artistId: 'artist_456');
final album = await musicService.getAlbumById('album_789');
```

## 📝 Playlist Service

```dart
// Get user playlists
final playlists = await playlistService.getUserPlaylists();

// Create playlist
final playlist = await playlistService.createPlaylist(
  name: 'My Favorites',
  description: 'Best songs',
  isPublic: true,
);

// Get playlist by ID
final playlist = await playlistService.getPlaylistById('playlist_123');

// Add track
await playlistService.addTrackToPlaylist('playlist_123', 'track_456');

// Remove track
await playlistService.removeTrackFromPlaylist('playlist_123', 'track_456');

// Update playlist
await playlistService.updatePlaylist(
  playlistId: 'playlist_123',
  name: 'New Name',
  isPublic: false,
);

// Delete playlist
await playlistService.deletePlaylist('playlist_123');
```

## 🔍 Search Service

```dart
// Global search
final results = await searchService.search(
  query: 'love',
  types: ['track', 'artist', 'album'],
  limit: 20,
);
print('Tracks: ${results.tracks.length}');
print('Artists: ${results.artists.length}');

// Search tracks only
final tracks = await searchService.searchTracks(query: 'love', limit: 20);

// Search artists
final artists = await searchService.searchArtists(query: 'taylor', limit: 10);

// Search albums
final albums = await searchService.searchAlbums(query: 'greatest hits');

// Autocomplete suggestions
final suggestions = await searchService.getSuggestions(query: 'lov', limit: 10);
```

## 👤 User Service

```dart
// Get current user
final user = await userService.getCurrentUser();

// Update profile
final updated = await userService.updateCurrentUser(
  displayName: 'New Name',
  bio: 'Music lover',
  favoriteGenres: ['Pop', 'Rock'],
);

// Get favorites
final favorites = await userService.getUserFavorites(limit: 50);

// Add to favorites
await userService.addFavorite('track_123', 'track');

// Remove from favorites
await userService.removeFavorite('track_123');
```

## 🎯 Provider Usage (trong Widget)

```dart
// Login with AuthProviderV2
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProviderV2>();

    return ElevatedButton(
      onPressed: auth.isLoading ? null : () async {
        await auth.login('email', 'password');
        if (auth.error == null) {
          // Success!
        }
      },
      child: auth.isLoading
        ? CircularProgressIndicator()
        : Text('Login'),
    );
  }
}
```

## ⚠️ Error Handling

```dart
try {
  await authService.login(email: email, password: password);
} on AuthException catch (e) {
  print('Auth error: ${e.message}');
} on ValidationException catch (e) {
  print('Validation: ${e.message}');
  print('Fields: ${e.errors}');
} on NetworkException catch (e) {
  print('Network: ${e.message}');
} on ServerException catch (e) {
  print('Server: ${e.message}');
} catch (e) {
  print('Unknown: $e');
}
```

## 🌍 Environment Configuration

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=prod
```

## 📍 Endpoint Configuration

Edit `lib/core/config/api_config.dart`:

```dart
'dev': {
  'auth': 'http://localhost:8001',
  'music': 'http://localhost:8002',
  'user': 'http://localhost:8003',
  'playlist': 'http://localhost:8004',
  'search': 'http://localhost:8005',
},
```

## 🔧 Custom Endpoints

```dart
// In ApiConfig
static const String myNewEndpoint = '/api/v1/my-endpoint';

// Use in service
final response = await _apiClient.get(
  ApiConfig.musicServiceUrl,
  ApiConfig.myNewEndpoint,
  fromJson: (json) => MyModel.fromJson(json),
);
```

## 📦 Models

```dart
// Track
Track(
  id: 'track_1',
  title: 'Song Name',
  artist: 'Artist',
  albumArtUrl: 'https://...',
  durationMs: 180000,
  audioUrl: 'https://...',
  lyricUrl: 'https://...',
)

// Album
Album(id, title, artistId, artistName, coverUrl, releaseYear, trackIds)

// Artist
Artist(id, name, imageUrl, bio, monthlyListeners, isVerified, genres)

// Playlist
Playlist(id, name, description, coverUrl, ownerId, ownerName,
         isPublic, trackCount, trackIds, createdAt, updatedAt)

// User
UserModel(userId, displayName, userType, email, dateOfBirth,
          gender, profileImageUrl, bio, dateCreated, favoriteGenres)
```

## 💡 Tips

1. **Always initialize ServiceLocator in main()**
2. **Use AuthProviderV2 instead of old AuthProvider**
3. **Check `authService.isAuthenticated` before calling protected endpoints**
4. **Services auto-handle token in headers**
5. **All requests auto-logged to console**
6. **Use try-catch with specific exception types**
7. **Paginated responses include hasNext/hasPrevious**

## 📚 More Info

- `FASTAPI_MICROSERVICES_GUIDE.md` - Complete guide
- `lib/examples/service_usage_examples.dart` - Full examples
- `MICROSERVICES_IMPLEMENTATION_SUMMARY.md` - Architecture overview
