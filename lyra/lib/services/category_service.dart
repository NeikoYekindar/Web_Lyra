import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = 'https://your-api-domain.com/api';
  
  // Model cho Category
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token', // Nếu cần authentication
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Giả sử API trả về format: {"categories": ["All", "Music", "Podcasts"]}
        final List<dynamic> categoriesJson = jsonResponse['categories'];
        return categoriesJson.cast<String>();
        
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      // Trả về dữ liệu mặc định nếu API lỗi
      return ['All', 'Music', 'Podcasts'];
    }
  }
  
  // Lấy nội dung theo category
  static Future<Map<String, dynamic>> getContentByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content?category=${Uri.encodeComponent(category)}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching content: $e');
      return {};
    }
  }
}

// Model classes cho dữ liệu từ API
class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int count;
  
  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      count: json['count'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'count': count,
    };
  }
}