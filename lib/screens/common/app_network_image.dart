import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pjt/theme/app_theme.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium);

    return ClipRRect(
      borderRadius: radius,
      child: imageUrl == null || imageUrl!.isEmpty
          ? _ImageFallback(
              width: width,
              height: height,
              icon: fallbackIcon,
              iconColor: theme.colorScheme.primary.withValues(alpha: 0.24),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) =>
                  _ImagePlaceholder(width: width, height: height),
              errorWidget: (context, url, error) => _ImageFallback(
                width: width,
                height: height,
                icon: fallbackIcon,
                iconColor: theme.colorScheme.error.withValues(alpha: 0.55),
              ),
            ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const _ImagePlaceholder({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final double? width;
  final double? height;
  final IconData icon;
  final Color iconColor;

  const _ImageFallback({
    this.width,
    this.height,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}
