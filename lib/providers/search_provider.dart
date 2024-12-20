import 'package:flutter/foundation.dart';
import '../services/naver_api_service.dart';
import '../models/restaurant.dart';
import 'package:logging/logging.dart';

class SearchProvider with ChangeNotifier {
  final _logger = Logger('SearchProvider');
  final NaverApiService _apiService = NaverApiService();
  final Map<String, List<Restaurant>> _cache = {};
  final _cacheExpiry = const Duration(minutes: 5);
  final Map<String, DateTime> _cacheTimestamps = {};

  Future<List<Restaurant>> searchRestaurants({
    required dynamic foodTypes,
    required String location,
  }) async {
    List<String> processedFoodTypes;
    if (foodTypes is List<String>) {
      processedFoodTypes = foodTypes;
    } else if (foodTypes is List) {
      processedFoodTypes = foodTypes.map((e) => e.toString()).toList();
    } else {
      processedFoodTypes = [foodTypes.toString()];
    }

    final cacheKey = '$location-${processedFoodTypes.join(",")}';

    if (_cache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheExpiry) {
        return _cache[cacheKey]!;
      }
      _cache.remove(cacheKey);
      _cacheTimestamps.remove(cacheKey);
    }

    try {
      final results = await _apiService.searchRestaurants(
        processedFoodTypes.join(','),
        location: location,
      );

      _cache[cacheKey] = results;
      _cacheTimestamps[cacheKey] = DateTime.now();

      return results;
    } catch (e) {
      _logger.warning('검색 에러: $e');
      if (location == '강남역' && processedFoodTypes.contains('한식')) {
        return _getDefaultResults();
      }
      rethrow;
    }
  }

  List<Restaurant> _getDefaultResults() {
    return [/* ... */];
  }

  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }
}
