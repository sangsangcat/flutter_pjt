import 'package:flutter/material.dart';

class AppTheme {
  // Palette
  // 컬러 헌트 팔레트 #F6F4EB / #91C8E4 / #749BC2 / #4682A9 를
  // 배경, 보조 브랜드, 브랜드, 강조색의 역할로 나눠 전체 UI의 톤을 맞춘다.
  static const Color primaryColor = Color(0xFF4682A9);
  static const Color secondaryColor = Color(0xFF749BC2);
  static const Color notificationColor = Color(0xFFD14D72);
  static const Color dangerColor = Color(0xFFD9534F);
  static const Color warningColor = Color(0xFFF0B95F);
  static const Color successColor = Color(0xFF749BC2);

  // Surface tones
  // 배경과 카드, 입력창이 서로 너무 튀지 않도록 한 단계씩만 차이를 둔다.
  // 배경은 팔레트의 파란 계열에 맞춘 아주 옅은 블루-그레이로 두고,
  // 카드와 입력창은 그 위에서만 살짝 밝고 선명하게 보이도록 맞춘다.
  static const Color backgroundColor = Color(0xFFF1F6FB);
  static const Color cardColor = Color(0xFFFAFCFE);
  static const Color inputFillColor = Color(0xFFE5EFF7);

  // Typography and spacing tokens
  // 화면 곳곳에서 반복되는 곡률과 간격을 한곳에 묶어 레이아웃 밀도를 통일한다.
  static const Color textPrimary = Color(0xFF2E4B66);
  static const Color textSecondary = Color(0xFF5D748B);
  static const double commonRadius = 12.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = commonRadius;
  static const double radiusLarge = 16.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 32.0;

  // 화면별 styleFrom 중복을 줄이기 위한 버튼 helper.
  // 버튼의 "역할"을 이름으로 남겨야 이후 테마 수정 시 같은 의도의 버튼을 한 번에 조정할 수 있다.
  static ButtonStyle compactPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(100, 36),
      elevation: 3,
      shadowColor: primaryColor.withValues(alpha: 0.20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
    );
  }

  static ButtonStyle subtleOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: textPrimary.withValues(alpha: 0.6),
      side: BorderSide(color: textPrimary.withValues(alpha: 0.2)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      minimumSize: const Size(0, 36),
    );
  }

  static ButtonStyle dangerTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: dangerColor.withValues(alpha: 0.7),
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  static ButtonStyle accentTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  static ButtonStyle compactOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(minimumSize: const Size(0, 52));
  }

  static ButtonStyle drawerHeaderActionButtonStyle() {
    return ElevatedButton.styleFrom(
      // Drawer 헤더 안에서만 쓰는 예외 버튼이라, 상단 배경과 색 대비를 더 준다.
      backgroundColor: cardColor,
      foregroundColor: primaryColor,
      elevation: 2,
      shadowColor: primaryColor.withValues(alpha: 0.16),
      minimumSize: const Size(0, 32),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      side: BorderSide(color: primaryColor.withValues(alpha: 0.12)),
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    );
  }

  static ButtonStyle onPrimaryFilledButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: primaryColor,
      elevation: 3,
      shadowColor: primaryColor.withValues(alpha: 0.18),
      minimumSize: const Size(0, 36),
    );
  }

  static ButtonStyle onPrimaryOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      side: BorderSide(color: backgroundColor.withValues(alpha: 0.54)),
      foregroundColor: backgroundColor,
      backgroundColor: primaryColor.withValues(alpha: 0.10),
      elevation: 1,
      shadowColor: primaryColor.withValues(alpha: 0.10),
      minimumSize: const Size(0, 36),
    );
  }

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

      // Surface themes
      // 카드, 앱바, 입력창, 다이얼로그처럼 반복되는 Material 표면을 같은 톤으로 묶는다.
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 4,
        shadowColor: primaryColor.withValues(alpha: 0.18),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(commonRadius),
          side: BorderSide(
            color: primaryColor.withValues(alpha: 0.1),
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

      // Button themes
      // 기본 버튼 위계를 여기서 잡아두면 화면별 styleFrom 남발을 줄일 수 있다.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          minimumSize: const Size(double.infinity, 54),
          elevation: 4, // 버튼은 배경에서 확실히 분리되도록 그림자 부여
          shadowColor: primaryColor.withValues(alpha: 0.24),
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
          backgroundColor: cardColor,
          elevation: 2,
          shadowColor: primaryColor.withValues(alpha: 0.12),
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

      // Shared components
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: primaryColor,
        disabledColor: inputFillColor.withValues(alpha: 0.6),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.12)),
        elevation: 1,
        pressElevation: 3,
        shadowColor: primaryColor.withValues(alpha: 0.12),
        selectedShadowColor: primaryColor.withValues(alpha: 0.18),
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

      badgeTheme: const BadgeThemeData(
        backgroundColor: notificationColor,
        textColor: cardColor,
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
        headlineSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        labelSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      ),
    );
  }
}
