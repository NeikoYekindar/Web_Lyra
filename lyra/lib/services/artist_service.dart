import 'dart:async';
import 'package:http/http.dart' as http;

class ArtistService {
  // Base URL - using production server
  static const String baseUrl = 'http://54.147.43.30:3000';

  static Future<Map<String, dynamic>> getArtistInfo(String artistName) async {
    // TODO: Gọi API thật của bạn ở đây. Ví dụ: GET /api/artists?name=$artistName
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập mạng

    // Dữ liệu mẫu trả về
    return {
      'name': artistName,
      'image':
          'https://i.scdn.co/image/ab6761610000e5ebc5216315263a233405c1d3f9', // Ảnh Sơn Tùng
      'listeners': '2,044,507 monthly listeners',
      'isVerified': true,
    };
  }

  /// Follow artist
  /// Endpoint: POST /artists/follow-artist/{artist_id}
  /// Uses token authentication to identify user
  static Future<bool> followArtist({required String artistId}) async {
    try {
      final url = Uri.parse('$baseUrl/artists/follow-artist/$artistId');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully followed artist: $artistId');
        return true;
      } else {
        print(
          'Follow artist failed: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error following artist: $e');
      return false;
    }
  }

  /// Unfollow artist
  /// Endpoint: POST /artists/unfollow-artist/{artist_id}
  /// Uses token authentication to identify user
  static Future<bool> unfollowArtist({required String artistId}) async {
    try {
      final url = Uri.parse('$baseUrl/artists/unfollow-artist/$artistId');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Successfully unfollowed artist: $artistId');
        return true;
      } else {
        print(
          'Unfollow artist failed: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error unfollowing artist: $e');
      return false;
    }
  }

  /// Check if user is following artist
  /// TODO: Implement endpoint để check follow status nếu backend có
  static Future<bool> isFollowingArtist({
    required String artistId,
    required String userId,
  }) async {
    // Placeholder - implement khi có endpoint
    return false;
  }
}
