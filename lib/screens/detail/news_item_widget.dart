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
    return ListTile(
      leading: article.urlToImage != null
          ? Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  // [수정] NetworkImage를 CachedNetworkImageProvider로 교체
                  image: CachedNetworkImageProvider(article.urlToImage!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
            ),
      title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            article.source ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ],
      ),
      onTap: _launchUrl,
    );
  }
}
