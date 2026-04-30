import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/news_article.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsArticle article;

  const NewsItemWidget(this.article, {super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(article.url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // [수정] 직접 CachedNetworkImage를 사용하여 로딩 UI 제어 강화
        child: article.urlToImage != null
            ? CachedNetworkImage(
                imageUrl: article.urlToImage!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 64,
                  height: 64,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 64,
                  height: 64,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined, size: 20),
                ),
              )
            : Container(
                width: 64,
                height: 64,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.article_outlined, 
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
      ),
      title: Text(
        article.title, 
        maxLines: 2, 
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            article.source ?? '뉴스 출처',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12, 
              color: theme.colorScheme.primary, // [수정] 브랜드 네이비 적용
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: _launchUrl,
    );
  }
}
