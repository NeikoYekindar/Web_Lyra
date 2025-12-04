import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Simple service to fetch currently playing track from backend.
class NowPlayingService {
  final String baseUrl;
  const NowPlayingService({required this.baseUrl});

  Uri _url(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> fetchNowPlaying() async {
    try {
      final resp = await http
          .get(_url('/player/now-playing'), headers: const {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final json = jsonDecode(resp.body);
        if (json is Map<String, dynamic>) return json;
        throw Exception('Invalid now-playing payload');
      }

      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    } on SocketException {
      throw Exception('Không kết nối được server');
    } on TimeoutException {
      throw Exception('Yêu cầu quá thời gian');
    } catch (e) {
      throw Exception('Lỗi now-playing: $e');
    }
  }
}
