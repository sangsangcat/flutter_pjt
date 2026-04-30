import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pjt/firebase_options.dart'; // flutterfire configure 실행 후 생성됨
import 'package:flutter_pjt/models/trip_destination.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:flutter_pjt/providers/trip_provider.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/providers/wishlist_provider.dart';
import 'package:flutter_pjt/providers/booking_provider.dart';
import 'package:flutter_pjt/screens/about/about_screen.dart';
import 'package:flutter_pjt/screens/destination/destination_screen.dart';
import 'package:flutter_pjt/screens/auth/account_setting/account_setting_screen.dart';
import 'package:flutter_pjt/screens/auth/login_screen.dart';
import 'package:flutter_pjt/screens/auth/signup_screen.dart';
import 'package:flutter_pjt/screens/wishlist/wishlist_screen.dart';
import 'package:flutter_pjt/screens/booking/booking_screen.dart';
import 'package:flutter_pjt/theme/app_theme.dart'; // 테마 파일 임포트
import 'package:provider/provider.dart';
import './routes/app_routes.dart';
import './screens/home/home_screen.dart';

void main() async {
  // 비동기 초기화를 위해 바인딩 확인 및 Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TripApp());
}

class TripApp extends StatelessWidget {
  const TripApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 테마설정 + 라우팅 등록 + 앱 전역 상태 등록
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TripProvider()..loadDestinations(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserData()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        // ProxyProvider를 사용하여 UserProvider의 로그인 상태(userId)를 연동
        ChangeNotifierProxyProvider<UserProvider, WishlistProvider>(
          create: (_) => WishlistProvider(),
          update: (_, userProvider, wishlistProvider) =>
              wishlistProvider!..updateUserId(userProvider.userId),
        ),
        ChangeNotifierProxyProvider<UserProvider, BookingProvider>(
          create: (_) => BookingProvider(),
          update: (_, userProvider, bookingProvider) =>
              bookingProvider!..updateUserId(userProvider.userId),
        ),
      ],
      child: MaterialApp(
        // 정의한 공통 테마 적용
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.about: (context) => AboutScreen(),
          AppRoutes.accountSetting: (context) => const AccountSettingScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.signup: (context) => const SignupScreen(),
          // [추가] 관심상품 및 예약 목록 라우트 등록
          AppRoutes.wishlist: (context) => const WishlistScreen(),
          AppRoutes.booking: (context) => const BookingScreen(),
        },
        onGenerateRoute: (settings) {
          // 어디선가 routing 명령 내려졌을때..코드 진행..
          if (settings.name == AppRoutes.destination) {
            // 요청시 추가된 전달 데이터 획득..
            final destination = settings.arguments as TripDestination;
            return MaterialPageRoute(
              builder: (context) => DestinationScreen(destination),
            );
          }
          return null;
        },
      ),
    );
  }
}
