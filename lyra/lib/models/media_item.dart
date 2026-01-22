/// Abstract interface for media items that can be displayed in cards
/// Both Track and Playlist can implement this interface
abstract class MediaItem {
  String get title;
  String get subtitle; // Artist for Track, Owner for Playlist
  String? get imageUrl;
  String? get additionalInfo; // Duration for Track, Song count for Playlist
}
