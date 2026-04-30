import 'package:flutter/material.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

class AppListCard extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const AppListCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: margin,
      elevation: theme.cardTheme.elevation ?? 3,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.14),
      // 반복되는 리스트형 카드는 같은 padding/배치를 써야 화면마다 정보 밀도가 흔들리지 않음
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingSm,
        ),
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
