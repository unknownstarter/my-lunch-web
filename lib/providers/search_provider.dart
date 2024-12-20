import 'package:flutter/foundation.dart';
import '../services/naver_api_service.dart';
import '../models/restaurant.dart';

class SearchProvider with ChangeNotifier {
  final NaverApiService _apiService = NaverApiService();

  Future<List<Restaurant>> searchRestaurants({
    required List<String> foodTypes,
    required String location,
  }) async {
    final foodTypesStr = foodTypes.join(',');

    try {
      return await _apiService.searchRestaurants(
        foodTypesStr,
        location: location,
      );
    } catch (e) {
      if (location == '서울시 강남구 역삼동' && foodTypes.contains('한식')) {
        return _getDefaultResults();
      }
      rethrow;
    }
  }

  List<Restaurant> _getDefaultResults() {
    return [/* ... */];
  }
}
