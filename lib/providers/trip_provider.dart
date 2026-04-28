import 'package:flutter/material.dart';
import '../models/trip_destination.dart';

class TripProvider with ChangeNotifier {
  final List<TripDestination> _destinations = [
    TripDestination(
      name: '스위스',
      country: 'Swiss',
      description: '아름다운 알프스 산맥과 호수로 유명한 스위스',
      imagePath: 'assets/images/main_swiss.jpg',
      discount: '최대 20% 할인',
      products: [
        TravelProduct(
          title: '스위스 여행 상품 1',
          date: '1월 1일 ~ 1월 15일',
          duration: '14박 15일',
          price: '350만원',
          airline: '대한항공',
          hotel: '전 일정 4성급 이상 호텔',
          schedules: [
            '인천공항 출발 (대한항공 KE093, 13:20)',
            '취리히 공항 도착 후 호텔 체크인',
            '취리히 구시가지 자유 관광',
            '루체른 이동 (약 1시간)',
            '카펠교 및 빈사의 사자상 관람',
            '리기산 등반 및 파노라마 전망 감상',
            '인터라켄 이동 (약 2시간)',
            '융프라우요흐 등반 (유럽의 지붕, 3,454m)',
            '알프스 설원 자유 시간',
          ],
        ),
        TravelProduct(
          title: '스위스 알프스 힐링 투어',
          date: '5월 10일 ~ 5월 17일',
          duration: '7박 8일',
          price: '240만원',
          airline: '아시아나 항공',
          hotel: '인터라켄 호수 전망 호텔',
          schedules: [
            '인천 출발 및 제네바 도착',
            '몽트뢰 시옹 성 투어',
            '그린델발트 하이킹 체험',
            '베른 구시가지 투어 (유네스코 유산)',
            '취리히 쇼핑 및 마지막 만찬',
          ],
        ),
        TravelProduct(
          title: '스위스 만년설 원정대',
          date: '12월 20일 ~ 12월 27일',
          duration: '7박 8일',
          price: '280만원',
          airline: '스위스 항공',
          hotel: '스키 리조트급 산장 호텔',
          schedules: [
            '취리히 공항 가이드 미팅',
            '체르마트 이동 및 마테호른 감상',
            '빙하 특급 열차 탑승 (세인트모리츠행)',
            '루체른 야경 및 온천욕',
          ],
        ),
        TravelProduct(
          title: '취리히 & 루체른 시티 브레이크',
          date: '9월 1일 ~ 9월 6일',
          duration: '5박 6일',
          price: '190만원',
          airline: '핀에어',
          hotel: '시내 중심가 4성급 호텔',
          schedules: [
            '취리히 미술관 관람',
            '루체른 호수 유람선 탑승',
            '무제크 성벽 산책',
          ],
        ),
      ],
    ),
    TripDestination(
      name: '호주',
      country: 'Australia',
      description: '광활한 자연과 독특한 문화를 체험할 수 있는 호주',
      imagePath: 'assets/images/main_australia.jpg',
      discount: '최대 10% 할인',
      products: [
        TravelProduct(
          title: '시드니 & 멜버른 완전 정복',
          date: '10월 1일 ~ 10월 10일',
          duration: '9박 10일',
          price: '310만원',
          airline: '콴타스 항공',
          hotel: '특급 호텔 및 시티 아파트먼트',
          schedules: [
            '시드니 오페라 하우스 투어',
            '본다이 비치 서핑 체험',
            '블루마운틴 국립공원 방문',
            '멜버른 이동 및 그레이트 오션 로드 투어',
            '퍼핑 빌리 증기 기차 체험',
          ],
        ),
        TravelProduct(
          title: '골드코스트 서핑 & 테마파크',
          date: '11월 15일 ~ 11월 21일',
          duration: '6박 7일',
          price: '220만원',
          airline: '진에어',
          hotel: '해변 앞 리조트',
          schedules: [
            '서퍼스 파라다이스 휴양',
            '무비월드 & 씨월드 관람',
            '브리즈번 시티 투어',
          ],
        ),
        TravelProduct(
          title: '케언즈 그레이트 배리어 리프',
          date: '12월 5일 ~ 12월 11일',
          duration: '6박 7일',
          price: '260만원',
          airline: '젯스타',
          hotel: '해안가 럭셔리 리조트',
          schedules: [
            '그레이트 배리어 리프 스노클링',
            '쿠란다 열대우림 마을 투어',
            '나이트 마켓 쇼핑',
          ],
        ),
        TravelProduct(
          title: '서호주 퍼스 로트네스트 투어',
          date: '1월 20일 ~ 1월 27일',
          duration: '7박 8일',
          price: '280만원',
          airline: '싱가포르 항공',
          hotel: '퍼스 중심가 부티크 호텔',
          schedules: [
            '퍼스 시내 관광 및 킹스 파크',
            '로트네스트 섬 쿼카 만나기',
            '피나클스 사막 별빛 투어',
          ],
        ),
      ],
    ),
    TripDestination(
      name: '조지아',
      country: 'Georgia',
      description: '코카서스의 숨겨진 왕국 조지아',
      imagePath: 'assets/images/main_georgia.jpg',
      discount: '최대 10% 할인',
      products: [
        TravelProduct(
          title: '코카서스 산맥 대탐험',
          date: '6월 10일 ~ 6월 19일',
          duration: '9박 10일',
          price: '230만원',
          airline: '카타르 항공',
          hotel: '전통 가옥 및 부티크 호텔',
          schedules: [
            '트빌리시 올드시티 투어',
            '카즈베기 스테판츠민다 하이킹',
            '므츠헤타 유네스코 유산 관람',
            '시그나기 와인 시음회',
          ],
        ),
        TravelProduct(
          title: '조지아 와이너리 투어',
          date: '9월 20일 ~ 9월 26일',
          duration: '6박 7일',
          price: '190만원',
          airline: '에미레이트 항공',
          hotel: '와이너리 소유 리조트',
          schedules: [
            '카헤티 와인 산지 방문',
            '쿠베브리(전통 항아리) 제조 관람',
            '전통 요리 만들기 체험',
          ],
        ),
        TravelProduct(
          title: '조지아 올드 트빌리시 워킹 투어',
          date: '5월 1일 ~ 5월 7일',
          duration: '6박 7일',
          price: '170만원',
          airline: '터키 항공',
          hotel: '역사 지구 4성급 호텔',
          schedules: [
            '트빌리시 케이블카 탑승',
            '나리칼라 요새 관람',
            '유황 온천 체험',
          ],
        ),
      ],
    ),
    TripDestination(
      name: '몽골',
      country: 'Mongolia',
      description: '끝없는 초원과 유목민의 나라',
      imagePath: 'assets/images/main_mongolia.jpg',
      discount: '최대 10% 할인',
      products: [
        TravelProduct(
          title: '고비 사막 쏟아지는 별빛 투어',
          date: '7월 1일 ~ 7월 10일',
          duration: '9박 10일',
          price: '210만원',
          airline: 'MIAT 몽골항공',
          hotel: '전통 가옥 게르(Ger) 체험',
          schedules: [
            '울란바토르 시내 관광',
            '테를지 국립공원 말 타기 체험',
            '바양작 불타는 절벽 관람',
            '홍고린엘스 사구 모래썰매',
          ],
        ),
        TravelProduct(
          title: '몽골 북부 홉스굴 호수 힐링',
          date: '8월 10일 ~ 8월 17일',
          duration: '7박 8일',
          price: '180만원',
          airline: '제주항공',
          hotel: '호숫가 고급 게르 캠프',
          schedules: [
            '홉스굴 호수 유람선 탑승',
            '순록 유목민 마을 방문',
            '초원 위 요가 및 명상',
          ],
        ),
        TravelProduct(
          title: '몽골 역사와 대초원 원정대',
          date: '6월 15일 ~ 6월 22일',
          duration: '7박 8일',
          price: '160만원',
          airline: '아시아나 항공',
          hotel: '울란바토르 5성급 호텔 & 게르',
          schedules: [
            '징기스칸 기마상 관람',
            '차강 소브라가(아시아의 그랜드 캐년)',
            '고비 구르반 사이한 국립공원',
          ],
        ),
      ],
    ),
    TripDestination(
      name: '네팔',
      country: 'Nepal',
      description: '소박하지만 화려한 빛을 내는 나라',
      imagePath: 'assets/images/main_nepal.jpg',
      discount: '최대 10% 할인',
      products: [
        TravelProduct(
          title: '안나푸르나 베이스캠프 트레킹',
          date: '10월 15일 ~ 10월 28일',
          duration: '13박 14일',
          price: '250만원',
          airline: '대한항공',
          hotel: '카트만두 호텔 및 로지(Lodge)',
          schedules: [
            '카트만두 유적지 투어',
            '포카라 이동 및 트레킹 시작',
            '데우랄리 - ABC 도달',
            '지누단다 천연 온천',
          ],
        ),
        TravelProduct(
          title: '카트만두 & 포카라 시티 투어',
          date: '3월 10일 ~ 3월 17일',
          duration: '7박 8일',
          price: '140만원',
          airline: '타이 항공',
          hotel: '히말라야 전망 4성급 호텔',
          schedules: [
            '스와얌부나트 사원 관람',
            '페와 호수 보트 투어',
            '사랑코트 일출 감상',
          ],
        ),
        TravelProduct(
          title: '치트완 사파리 탐험대',
          date: '11월 5일 ~ 11월 12일',
          duration: '7박 8일',
          price: '160만원',
          airline: '에어 인디아',
          hotel: '정글 사파리 리조트',
          schedules: [
            '치트완 국립공원 정글 트레킹',
            '코뿔소 & 벵갈 호랑이 탐색',
            '카누 타기 및 악어 관람',
          ],
        ),
      ],
    ),
    TripDestination(
      name: '하와이',
      country: 'Hawaii',
      description: '세계 허니무너들의 지상낙원',
      imagePath: 'assets/images/main_hawaii.jpg',
      discount: '최대 10% 할인',
      products: [
        TravelProduct(
          title: '오아후 & 마우이 럭셔리 투어',
          date: '5월 1일 ~ 5월 8일',
          duration: '7박 8일',
          price: '380만원',
          airline: '하와이안 항공',
          hotel: '힐튼 & 쉐라톤 리조트',
          schedules: [
            '와이키키 비치 휴양',
            '진주만 기념관 방문',
            '할레아칼라 국립공원 일출',
            '하나로드 드라이빙 투어',
          ],
        ),
        TravelProduct(
          title: '하와이 아일랜드 화산 국립공원 투어',
          date: '6월 10일 ~ 6월 17일',
          duration: '7박 8일',
          price: '350만원',
          airline: '대한항공',
          hotel: '화산 국립공원 근처 롯지',
          schedules: [
            '빅아일랜드 화산 탐방',
            '마우나케아 별빛 관측',
            '블랙 샌드 비치 방문',
          ],
        ),
        TravelProduct(
          title: '카우아이 가든 아일랜드 투어',
          date: '9월 20일 ~ 9월 27일',
          duration: '7박 8일',
          price: '320만원',
          airline: '델타 항공',
          hotel: '가든 뷰 리조트',
          schedules: [
            '와이메아 캐년 관람',
            '나팔리 코스트 보트 투어',
            '포이푸 비치 휴양',
          ],
        ),
      ],
    ),
  ];

  List<TripDestination> get destination => _destinations;

  // 이름으로 찾도록 수정
  TripDestination? getDestinationByName(String name) {
    try {
      return _destinations.firstWhere((destination) => destination.name == name);
    } catch (e) {
      return null;
    }
  }
}
