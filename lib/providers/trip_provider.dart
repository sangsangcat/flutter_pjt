import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/trip_destination.dart';
import '../services/database_helper.dart';

class TripProvider with ChangeNotifier {
  List<TripDestination> _allDestinations = []; // 서버 및 캐시에서 가져온 전체 데이터 원본
  bool _isLoading = false;
  String _selectedContinent = 'All'; // 현재 선택된 대륙 상태 (기본값: 전체)

  // UI에서 사용할 필터링된 리스트 반환
  List<TripDestination> get destination => filteredDestinations;
  bool get isLoading => _isLoading;
  String get selectedContinent => _selectedContinent;
  // [추가] 전체 목적지 리스트에 접근할 수 있는 게터
  List<TripDestination> get allDestinations => _allDestinations;

  // 대륙별 필터링 로직
  List<TripDestination> get filteredDestinations {
    if (_selectedContinent == 'All') {
      return _allDestinations;
    }
    return _allDestinations
        .where((d) => d.continent.toLowerCase() == _selectedContinent.toLowerCase())
        .toList();
  }

  // 대륙 필터 변경 함수
  void setContinent(String continent) {
    _selectedContinent = continent;
    notifyListeners(); // 상태 변경 알림 -> UI 자동 갱신
  }

  // [핵심 리팩토링] 데이터 로드 로직 최적화 (캐시 우선 방식)
  Future<void> loadDestinations() async {
    // 1. 먼저 로컬 DB 캐시를 비동기로 확인 (아직 notifyListeners를 호출하지 않음)
    try {
      final cachedData = await DatabaseHelper.instance.getCachedDestinations();
      
      if (cachedData.isNotEmpty) {
        // 캐시 데이터가 있으면 즉시 할당하고 로딩 바 없이 UI 갱신
        _allDestinations = cachedData;
        _isLoading = false;
        debugPrint("로컬 캐시 데이터 로드 완료: ${cachedData.length}개");
      } else {
        // 캐시가 아예 없으면 사용자가 기다려야 하므로 로딩 상태 활성화
        _isLoading = true;
      }
    } catch (e) {
      debugPrint("캐시 확인 중 오류: $e");
      _isLoading = true; // 에러 발생 시 안전하게 로딩 상태로 시작
    }
    
    // 첫 번째 UI 상태 알림 (캐시가 있다면 리스트가, 없다면 로딩 바가 뜸)
    notifyListeners();

    // 2. 서버에서 최신 데이터를 가져오는 과정 (백그라운드 업데이트)
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/destinations'),
      ).timeout(const Duration(seconds: 5)); // 타임아웃 설정

      if (response.statusCode == 200) {
        // 한글 깨짐 방지를 위해 utf8.decode 사용
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<TripDestination> remoteDestinations = data
            .map((item) => TripDestination.fromJson(item))
            .toList();

        // 서버에서 가져온 최신 데이터로 교체
        _allDestinations = remoteDestinations;
        
        // 3. 최신 데이터를 다시 로컬 DB에 캐싱하여 다음 앱 실행 시 활용
        await DatabaseHelper.instance.saveDestinations(remoteDestinations);
        debugPrint("서버 최신 데이터 동기화 및 캐싱 완료");
      }
    } catch (e) {
      // 서버 연결 실패 시 이미 표시 중인 캐시 데이터를 그대로 유지 (사용자는 계속 서비스를 이용 가능)
      debugPrint("서버 업데이트 실패 (캐시 모드 유지): $e");
    } finally {
      // 모든 작업이 끝나면 로딩 상태 해제 후 최종 UI 갱신
      _isLoading = false;
      notifyListeners(); // 로딩 종료 및 데이터 업데이트 알림
    }
  }

  // 이름으로 여행지 찾기 (전체 원본 데이터에서 검색)
  TripDestination? getDestinationByName(String name) {
    try {
      return _allDestinations.firstWhere(
        (destination) => destination.name == name,
      );
    } catch (e) {
      return null;
    }
  }

  // [추가] ID로 여행지 찾기 (관심상품/예약 목록 검색용)
  TripDestination? getDestinationById(int id) {
    try {
      return _allDestinations.firstWhere(
        (destination) => destination.id == id,
      );
    } catch (e) {
      return null;
    }
  }
}
