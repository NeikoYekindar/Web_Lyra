import 'dart:convert';
import 'package:http/http.dart' as http;
import 'left_sidebar_service.dart';

class PlaylistService {
  final String baseUrl;
  final String? authToken;

  PlaylistService({required this.baseUrl, this.authToken});

  /// Fetch "next playlists" for the current user.
  ///
  /// Adjust the endpoint path and response mapping to match your backend.
  /// Returns a list of plain maps suitable for UI consumption.
  Future<List<Map<String, dynamic>>> fetchUserNextPlaylists() async {
    final uri = Uri.parse('$baseUrl/user/next-playlists');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (authToken != null && authToken!.isNotEmpty) 'Authorization': 'Bearer $authToken',
    };

    final res = await http.get(uri, headers: headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final body = json.decode(res.body);
      // Expecting an array. If object with key like { data: [...] }, adjust accordingly.
      final List list = body is List ? body : (body['data'] as List? ?? []);
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception('Failed to load next playlists: ${res.statusCode} ${res.reasonPhrase}');
  }



  /// Test-only variant: return mocked playlists identical to LeftSidebarService demo.
  /// Useful while backend endpoint is not ready.
  Future<List<Map<String, dynamic>>> fetchUserNextPlaylists2() async {
    return await LeftSidebarService.getPlaylistsUser();
  }
}
