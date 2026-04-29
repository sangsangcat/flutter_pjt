import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pjt/firebase_options.dart'; // flutterfire configure 실행 후 생성됨
import 'package:flutter_pjt/models/trip_destination.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:flutter_pjt/providers/trip_provider.dart';
import 'package:flutter_pjt/providers/user_provider.dart';
import 'package:flutter_pjt/providers/wishlist_provider.dart';
import 'package:flutter_pjt/providers/booking_provider.dart';
import 'package:flutter_pjt/screens/about_screen.dart';
import 'package:flutter_pjt/screens/detail_screen.dart';
import 'package:flutter_pjt/screens/myinfo_screen.dart';
import 'package:flutter_pjt/screens/login_screen.dart';
import 'package:flutter_pjt/screens/signup_screen.dart';
import 'package:flutter_pjt/screens/wishlist_screen.dart'; // 추가
import 'package:flutter_pjt/screens/booking_screen.dart'; // 추가
import 'package:provider/provider.dart';
import './routes/app_routes.dart';
import './screens/home_screen.dart';

void main() async {
  // 비동기 초기화를 위해 바인딩 확인 및 Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  
  // flutterfire configure를 먼저 실행해야 FirebaseOptions.currentPlatform을 사용할 수 있다
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.about: (context) => AboutScreen(),
          AppRoutes.myInfo: (context) => MyinfoScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.signup: (context) => const SignupScreen(),
          // [추가] 관심상품 및 예약 목록 라우트 등록
          AppRoutes.wishlist: (context) => const WishlistScreen(),
          AppRoutes.booking: (context) => const BookingScreen(),
        },
        onGenerateRoute: (settings) {
          // 어디선가 routing 명령 내려졌을때..코드 진행..
          if (settings.name == AppRoutes.detail) {
            // 요청시 추가된 전달 데이터 획득..
            final destination = settings.arguments as TripDestination;
            return MaterialPageRoute(
              builder: (context) => DetailScreen(destination),
            );
          }
          return null;
        },
      ),
    );
  }
}
