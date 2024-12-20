import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSearchResult({
    required String location,
    required List<String> foodTypes,
    required String price,
    required String distance,
    required String? preference,
    required List<Restaurant> results,
  }) async {
    final batch = _firestore.batch();
    final searchRef = _firestore.collection('searches').doc();

    // 검색 결과의 레스토랑들을 restaurants 컬렉션에 저장
    final restaurantRefs = await Future.wait(
      results.map((restaurant) async {
        final restaurantRef = _firestore.collection('restaurants').doc();
        batch.set(restaurantRef, {
          'name': restaurant.name,
          'type': restaurant.type,
          'address': restaurant.address,
          'rating': restaurant.rating,
          'priceRange': _getPriceRangeNumber(price),
          'distance': restaurant.distance,
          'searchKeywords': [...foodTypes, if (preference != null) preference],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        return restaurantRef.id;
      }),
    );

    // 검색 기록 저장
    batch.set(searchRef, {
      'filters': {
        'cuisineTypes': foodTypes,
        'priceRange': _getPriceRangeNumber(price),
        'distance': _getDistanceNumber(distance),
        'preferences': preference,
      },
      'results': restaurantRefs,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  int _getPriceRangeNumber(String price) {
    switch (price) {
      case '1만원 미만':
        return 1;
      case '2만원대':
        return 2;
      case '3만원 이상':
        return 3;
      default:
        return 1;
    }
  }

  int _getDistanceNumber(String distance) {
    switch (distance) {
      case '5분 이내':
        return 5;
      case '10분':
        return 10;
      case '15분':
        return 15;
      case '20분 이상':
        return 20;
      default:
        return 10;
    }
  }
}
