import '../models/restaurant.dart';
import 'package:dio/dio.dart';

class NaverApiService {
  static const String baseUrl = String.fromEnvironment('API_URL',
      defaultValue: 'https://mylunchweb.netlify.app/.netlify/functions/search');

  final Dio _dio = Dio();

  Future<List<Restaurant>> searchRestaurants(
    String query, {
    required String location,
    required double maxDistance,
    required String priceRange,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/search/local.json',
        queryParameters: {
          'query': '$location $query',
          'display': 15,
          'sort': 'comment',
        },
      );

      if (response.data == null) {
        throw Exception('데이터가 없습니다');
      }

      final items = response.data!['items'] as List<dynamic>;
      return items.map((item) {
        final data = item as Map<String, dynamic>;
        return Restaurant(
          name: data['title'].toString().replaceAll(RegExp(r'<[^>]*>'), ''),
          type: data['category'].toString().split('>').last.trim(),
          address: data['roadAddress'] ?? data['address'],
          rating: double.tryParse(data['rating'] ?? '0') ?? 0.0,
          link: data['link'].toString().split('?').first,
          distance: double.tryParse(data['distance'] ?? '0') ?? 0.0,
          imageUrl: null,
        );
      }).toList();
    } catch (e) {
      throw Exception('검색 중 오류가 발생했습니다: $e');
    }
  }
}
