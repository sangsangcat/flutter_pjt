import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/trip_destination.dart';

class TripProvider with ChangeNotifier {
  List<TripDestination> _destinations = [];
  bool _isLoading = false;

  List<TripDestination> get destination => _destinations;
  bool get isLoading => _isLoading;

  // 서버에서 데이터를 가져오는 함수
  Future<void> loadDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 강사님 제공 주소 (안드로이드 에뮬레이터 기준)
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/destinations'));

      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위해 utf8.decode 사용
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        // JSON을 모델 객체로 변환하여 리스트에 할당
        _destinations = data.map((item) => TripDestination.fromJson(item)).toList();
      }
    } catch (e) {
      print("데이터 로드 실패: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 종료 및 데이터 업데이트 알림
    }
  }

  // 이름으로 찾도록 수정
  TripDestination? getDestinationByName(String name) {
    try {
      return _destinations.firstWhere((destination) => destination.name == name);
    } catch (e) {
      return null;
    }
  }
}
