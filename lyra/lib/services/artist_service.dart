import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;


class ArtistService {
  static Future<Map<String, dynamic>> getArtistInfo(String artistName) async {
    // TODO: Gọi API thật của bạn ở đây. Ví dụ: GET /api/artists?name=$artistName
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập mạng
    
    // Dữ liệu mẫu trả về
    return {
      'name': artistName,
      'image': 'https://i.scdn.co/image/ab6761610000e5ebc5216315263a233405c1d3f9', // Ảnh Sơn Tùng
      'listeners': '2,044,507 monthly listeners',
      'isVerified': true,
    };
  }
} 


