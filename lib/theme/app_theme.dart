import 'package:flutter/material.dart';

class AppTheme {
  // 1. 핵심 컬러 정의 (요청하신 #02343F, #F0EDCC 기반)
  static const Color primaryColor = Color(0xFF02343F); // 딥 틸 (신뢰감)
  static const Color secondaryColor = Color(0xFF337D71); // 중간 틸 (포인트)
  static const Color notificationColor = Color(
    0xFFD14D72,
  ); // 알림 배지와 선택된 하트에 쓰는 핑크 포인트

  // 배경 시스템: 흰색(#FFFFFF)이 너무 튀지 않도록 톤 온 톤 배색 적용
  static const Color backgroundColor = Color(0xFFF0EDCC); // 메인 배경 (샴페인 크림)
  static const Color cardColor = Color(0xFFF7F5E6); // 카드 배경 (배경보다 아주 살짝 밝은 크림)
  static const Color inputFillColor = Color(
    0xFFE5E2B3,
  ); // 입력창 배경 (배경보다 살짝 어두운 톤)

  static const Color textPrimary = Color(0xFF02343F); // 짙은 틸 (텍스트)
  static const Color textSecondary = Color(0xFF5E7A7D); // 차분한 틸 그레이
  static const double commonRadius = 12.0; // 화면별 곡률이 흩어지지 않도록 공통 기준값 제공

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: notificationColor,
        surface: backgroundColor,
        surfaceContainerHighest: inputFillColor,
        onSurface: textPrimary,
        onPrimary: backgroundColor,
        onSecondary: backgroundColor,
        onTertiary: backgroundColor,
      ),

      scaffoldBackgroundColor: backgroundColor,
      canvasColor: backgroundColor,
      dividerColor: primaryColor.withValues(alpha: 0.12),

      // 카드 테마: 흰색을 버리고 크림 톤을 유지하여 부드러운 레이어링 구현
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(commonRadius),
          side: BorderSide(
            color: primaryColor.withValues(alpha: 0.08),
          ), // 미세한 테두리로 구분
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),

      // 입력창 테마: 일관된 곡률과 배경색 적용
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(commonRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(commonRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(commonRadius),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),

      // 버튼 테마 통합 관리 (모양과 위계 일관성 확보)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          minimumSize: const Size(double.infinity, 54),
          elevation: 2, // 버튼은 배경에서 확실히 분리되도록 그림자 부여
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(commonRadius),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(commonRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(commonRadius),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),

      // 화면 곳곳의 선택 칩이 테마 변경을 자동으로 따라가도록 공통 Chip 스타일을 정의
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: primaryColor,
        disabledColor: inputFillColor.withValues(alpha: 0.6),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.12)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(commonRadius),
        ),
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: backgroundColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        showCheckmark: false,
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),

      // Dialog/ListTile/SnackBar처럼 화면에서 자주 쓰는 Material 위젯도 테마의 톤을 공유
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(commonRadius),
        ),
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: primaryColor,
        textColor: textPrimary,
      ),

      // Drawer 배지와 선택된 하트처럼 작은 상태 표시에만 핑크 포인트를 사용
      badgeTheme: const BadgeThemeData(
        backgroundColor: notificationColor,
        textColor: backgroundColor,
        textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: const TextStyle(color: backgroundColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(commonRadius),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      ),
    );
  }
}
