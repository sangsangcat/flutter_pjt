import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/trip_destination.dart';

class TripProvider with ChangeNotifier {
  List<TripDestination> _allDestinations = []; // 서버에서 가져온 전체 데이터 원본
  bool _isLoading = false;
  String _selectedContinent = 'All'; // 현재 선택된 대륙 상태 (기본값: 전체)

  // 기존 HomeScreen과의 호환성을 위해 destination 이름을 유지하되, 필터링된 리스트를 반환
  List<TripDestination> get destination => filteredDestinations;

  bool get isLoading => _isLoading;

  String get selectedContinent => _selectedContinent;

  // 현재 선택된 대륙에 따라 로컬에서 데이터를 필터링하여 반환
  List<TripDestination> get filteredDestinations {
    if (_selectedContinent == 'All') {
      return _allDestinations;
    }
    return _allDestinations
        .where(
          (d) => d.continent.toLowerCase() == _selectedContinent.toLowerCase(),
        )
        .toList();
  }

  // 대륙 필터 변경 함수 (서버 재요청 없이 로컬 상태만 변경하여 성능 최적화)
  void setContinent(String continent) {
    _selectedContinent = continent;
    notifyListeners(); // 상태 변경 알림 -> UI 자동 갱신
  }

  // 서버에서 데이터를 가져오는 함수
  Future<void> loadDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 강사님 제공 주소 (안드로이드 에뮬레이터 기준)
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/destinations'),
      );

      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위해 utf8.decode 사용
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        // JSON을 모델 객체로 변환하여 리스트에 할당 (전체 데이터 저장)
        _allDestinations = data
            .map((item) => TripDestination.fromJson(item))
            .toList();
      }
    } catch (e) {
      print("데이터 로드 실패: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 종료 및 데이터 업데이트 알림
    }
  }

  // 이름으로 찾도록 수정 (전체 원본 데이터에서 검색)
  TripDestination? getDestinationByName(String name) {
    try {
      return _allDestinations.firstWhere(
        (destination) => destination.name == name,
      );
    } catch (e) {
      return null;
    }
  }
}
