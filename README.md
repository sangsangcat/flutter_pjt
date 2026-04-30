# 🌍 Flutter 여행 정보 미니 프로젝트 (flutter_pjt)

이 프로젝트는 Flutter의 핵심 기능과 다양한 외부 라이브러리를 활용해 만든 학습용 여행 정보 애플리케이션입니다. Firebase 인증, Firestore 실시간 데이터 관리, SQLite 데이터 캐싱, Provider 기반 상태 관리, 그리고 Material 3 디자인 시스템을 하나의 흐름으로 묶어두었습니다.

최근에는 전역 테마와 공통 위젯을 정리해 화면마다 색상과 위계가 따로 놀지 않도록 다듬고 있습니다. 카드, 버튼, 칩, 빈 상태, 네트워크 이미지, 리스트 카드 같은 반복 UI는 공통화해서 유지보수성을 높였습니다.

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
- **디자인 시스템**: `AppTheme` 중심의 색상/간격/곡률/버튼/칩/카드/다이얼로그 공통 스타일 관리
- **공통 위젯**: `AppEmptyState`, `AppNetworkImage`, `AppListCard`로 반복 UI 패턴 통일

## 2. 🏛️ 시스템 아키텍처

이 프로젝트는 **Provider 패턴**을 기반으로 한 관심사 분리(Separation of Concerns) 아키텍처를 따릅니다.

- **UI Layer**: 사용자와 직접 상호작용하며 실시간 상태 변화를 즉각 반영하는 반응형 위젯들로 구성
- **State Management**: `ProxyProvider`를 사용하여 사용자 인증 상태(`userId`)를 추적하고, 유저별 실시간 데이터 스트림(Wishlist, Booking)을 격리하여 관리
- **Service Layer**: Firestore(실시간 DB), SQLite(로컬 캐시), API(네트워크 통신), Storage(파일 업로드) 등 다양한 데이터 소스를 캡슐화
- **Design Layer**: `lib/theme/app_theme.dart`에서 전역 팔레트, spacing/radius 토큰, 버튼 스타일, 텍스트 역할, Card/Chip/Dialog/Badge 테마를 통합 관리
- **Common Widgets**: `lib/screens/common/` 아래에 빈 상태, 네트워크 이미지, 리스트 카드 공통 위젯을 두어 반복 UI를 일관되게 유지

## 3. 📂 폴더 구조

```text
lib/
├── models/              # 데이터 모델 (UserInfo, Booking, NewsArticle, TripDestination)
├── providers/           # 상태 관리 (News, Trip, User, Wishlist, Booking Provider)
├── services/            # 데이터 서비스 (Auth, Firestore, News, Storage, DatabaseHelper)
├── screens/             # UI 화면
│   ├── common/         # 공통 위젯 (Empty State, Network Image, List Card)
│   ├── home/           # 홈 화면 및 하부 위젯 (Drawer, Grid, Search AppBar 등)
│   ├── detail/         # 상품 상세 정보, 상품 리스트, 뉴스 탭 위젯
│   ├── myinfo/         # 계정 설정, 프로필 편집, 빈 상태 위젯
│   ├── wishlist_screen.dart  # 관심 상품 목록 확인 및 삭제
│   ├── booking_screen.dart   # 예약 내역 확인, 가상 결제 및 취소 관리
│   └── (기타 화면들)
├── theme/              # 전역 테마 및 디자인 토큰
├── routes/              # Named Routes 설정
└── main.dart            # 앱 진입점 및 전역 MultiProvider 설정
```

## 4. 🛠️ 주요 기술 스택

- **Framework**: Flutter (Dart)
- **UI System**: Material 3, `ThemeData`, `ColorScheme`, `TextTheme`, 공통 위젯
- **State Management**: Provider (ChangeNotifierProxyProvider)
- **Backend**: Firebase (Authentication, Cloud Firestore, Storage)
- **Local Database**: sqflite (SQLite), shared_preferences
- **Networking**: http (News API)
- **Localization**: intl (날짜 및 시간 포맷팅)
- **Image Handling**: image_picker, cached_network_image

## 5. 🎨 디자인 시스템 요약

- 전역 색상과 표면 톤은 `AppTheme` 한 곳에서 관리합니다.
- 카드, 입력창, 버튼, 칩, 배지, 다이얼로그는 Material 3 테마를 우선 적용합니다.
- 빈 상태, 이미지 로딩, 리스트 카드처럼 반복되는 UI는 공통 위젯으로 통일합니다.
- Drawer 배지와 선택된 하트는 상태색을 유지하고, 나머지 UI는 테마 팔레트를 따르도록 분리합니다.

## 6. 📌 현재 진행 방향

- Phase 5 디자인 고도화는 완료되었습니다.
- Phase 6 디자인 시스템 정리 및 테마 재정비도 완료되었습니다.
