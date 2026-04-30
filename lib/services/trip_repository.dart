import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/trip_destination.dart';
import 'database_helper.dart';

// 여행지 데이터의 캐시/네트워크 접근을 분리해 Provider가 상태만 담당하도록 만든다.
class TripRepository {
  Future<List<TripDestination>> getCachedDestinations() async {
    return DatabaseHelper.instance.getCachedDestinations();
  }

  Future<List<TripDestination>> fetchRemoteDestinations() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/destinations'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      return [];
    }

    // 서버 응답을 모델로 바꾸는 작업은 저장 계층에서 처리해 ViewModel을 가볍게 유지한다.
    final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    return data.map((item) => TripDestination.fromJson(item)).toList();
  }

  Future<void> saveDestinations(List<TripDestination> destinations) async {
    await DatabaseHelper.instance.saveDestinations(destinations);
  }

  Future<TripDestination?> getCachedDestination(int id) async {
    return DatabaseHelper.instance.getCachedDestination(id);
  }
}
