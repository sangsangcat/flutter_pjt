import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pjt/screens/common/app_list_card.dart';
import 'package:flutter_pjt/screens/common/app_network_image.dart';
import '../../../models/news_article.dart';

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

    return AppListCard(
      leading: AppNetworkImage(
        imageUrl: article.urlToImage,
        width: 64,
        height: 64,
        fallbackIcon: article.urlToImage == null
            ? Icons.article_outlined
            : Icons.broken_image_outlined,
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
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary, // [수정] 브랜드 네이비 적용
            ),
          ),
        ],
      ),
      onTap: _launchUrl,
    );
  }
}
