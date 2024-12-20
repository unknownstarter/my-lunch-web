import 'package:flutter_test/flutter_test.dart';
import 'package:my_lunch_app/services/naver_api_service.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('Naver API Tests', () {
    final naverApiService = NaverApiService();

    test('검색 API 응답 테스트', () async {
      final response = await naverApiService.searchRestaurants(
        '맛집',
        location: '강남역',
      );

      // 응답 검증
      expect(response, isNotNull);
      expect(response, isList);
      expect(response.length, greaterThan(0), reason: '검색 결과가 없습니다');

      if (response.isNotEmpty) {
        debugPrint('\n=== 검색 결과 ===');
        for (var restaurant in response) {
          debugPrint('\n식당 정보:');
          debugPrint('이름: ${restaurant.name}');
          debugPrint('주소: ${restaurant.address}');
          debugPrint('카테고리: ${restaurant.type}');
          debugPrint('링크: ${restaurant.link}');
          debugPrint('거리: ${restaurant.distance}m');
          debugPrint('평점: ${restaurant.rating}');
          debugPrint('------------------------');
        }
        debugPrint('\n총 ${response.length}개의 결과를 찾았습니다.');
      }
    });
  });
}
