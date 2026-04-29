# 🌍 Flutter 여행 정보 미니 프로젝트 (flutter_pjt)

이 프로젝트는 Flutter의 핵심 기능과 다양한 외부 라이브러리를 활용하여 구축된 학습용 여행 정보 애플리케이션입니다. Firebase를 통한 인증, Firestore를 활용한 실시간 데이터 관리, SQLite 데이터 캐싱, Provider 기반의 상태 관리를 종합적으로 구현했습니다.

## 1. 📋 기획 의도 및 주요 기능

### 🎯 기획 의도
- Flutter의 MVVM 기반 아키텍처 및 복합 상태 관리(`ChangeNotifierProxyProvider`) 이해
- Firebase(Auth, Firestore, Storage) 연동을 통한 풀스택 앱 구조 실습
- SQLite 및 Shared Preferences를 이용한 로컬 데이터 캐싱 및 설정 관리
- 외부 API(News API)와의 네트워킹 및 실시간 데이터 바인딩 실습

### ✨ 주요 기능
- **사용자 인증**: Firebase Auth 기반 이메일/Google 로그인 및 회원가입
- **여행지 정보**: 여행지 목록 조회 및 SQLite 기반 오프라인 데이터 캐싱 (대륙별 필터링 포함)
- **뉴스 피드**: News API를 활용한 여행지 국가별 실시간 뉴스 제공
- **개인화 서비스 (Firestore 실시간 연동)**:
    - **관심 상품(Wishlist)**: 목적지 내 개별 상품 단위의 찜하기 기능 및 실시간 동기화
    - **예약 시스템(Booking)**: 특정 상품 예약, 대기/결제 상태 관리 및 예약 취소 기능
- **마이페이지**: 사용자 프로필 관리 및 이미지 업로드 (Firebase Storage 연동)
- **실시간 알림 UI**: Drawer 내 배지(Badge) 시스템을 활용한 관심상품/예약 개수 실시간 표시

## 2. 🏛️ 시스템 아키텍처

이 프로젝트는 **Provider 패턴**을 기반으로 한 관심사 분리(Separation of Concerns) 아키텍처를 따릅니다.

- **UI Layer**: 사용자와 직접 상호작용하며 실시간 상태 변화를 즉각 반영하는 반응형 위젯들로 구성
- **State Management**: `ProxyProvider`를 사용하여 사용자 인증 상태(`userId`)를 추적하고, 유저별 실시간 데이터 스트림(Wishlist, Booking)을 격리하여 관리
- **Service Layer**: Firestore(실시간 DB), SQLite(로컬 캐시), API(네트워크 통신), Storage(파일 업로드) 등 다양한 데이터 소스를 캡슐화

## 3. 📂 폴더 구조

```text
lib/
├── models/             # 데이터 모델 (UserInfo, Booking, NewsArticle, TripDestination)
├── providers/          # 상태 관리 (News, Trip, User, Wishlist, Booking Provider)
├── services/           # 데이터 서비스 (Auth, Firestore, News, Storage, DatabaseHelper)
├── screens/            # UI 화면
│   ├── home/           # 홈 화면 및 하부 위젯 (Drawer, Grid 등)
│   ├── detail/         # 상품 상세 정보, 상품 리스트, 뉴스 탭 위젯
│   ├── wishlist_screen.dart # 관심 상품 목록 확인 및 삭제
│   ├── booking_screen.dart  # 예약 내역 확인, 가상 결제 및 취소 관리
│   └── (기타 화면들)
├── routes/             # Named Routes 설정
└── main.dart           # 앱 진입점 및 전역 MultiProvider 설정
```

## 4. 🛠️ 주요 기술 스택

- **Framework**: Flutter (Dart)
- **State Management**: Provider (ChangeNotifierProxyProvider)
- **Backend**: Firebase (Authentication, Cloud Firestore, Storage)
- **Local Database**: sqflite (SQLite), shared_preferences
- **Networking**: http (News API)
- **Localization**: intl (날짜 및 시간 포맷팅)
- **Image Handling**: image_picker, cached_network_image
