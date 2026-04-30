import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'news_item_widget.dart';

class NewsListWidget extends StatelessWidget {
  final String country; // 국가명 추가

  const NewsListWidget(this.country, {super.key}); // super.key 및 const 추가

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //앱의 상태로 화면 구성..
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          );
        }
        if (newsProvider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline, 
                    size: 64, 
                    color: theme.colorScheme.error.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '뉴스를 불러올 수 없습니다.\n${newsProvider.error}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => newsProvider.fetchNews(country),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        }
        if (newsProvider.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  '관련 뉴스가 없습니다.', 
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: newsProvider.articles.length,
          itemBuilder: (context, index) {
            final article = newsProvider.articles[index];
            return Card(
              // [수정] AppTheme의 CardTheme을 따르도록 하드코딩된 마진 조정
              child: NewsItemWidget(article),
            );
          },
        );
      },
    );
  }
}
