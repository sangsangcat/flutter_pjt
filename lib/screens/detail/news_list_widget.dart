import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:flutter_pjt/screens/common/app_empty_state.dart';
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
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          );
        }
        if (newsProvider.error != null) {
          return AppEmptyState(
            icon: Icons.error_outline,
            title: '뉴스를 불러올 수 없습니다.',
            message: newsProvider.error,
            iconColor: theme.colorScheme.error.withValues(alpha: 0.7),
            action: ElevatedButton(
              onPressed: () => newsProvider.fetchNews(country),
              child: const Text('다시 시도'),
            ),
          );
        }
        if (newsProvider.articles.isEmpty) {
          return const AppEmptyState(
            icon: Icons.article_outlined,
            title: '관련 뉴스가 없습니다.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: newsProvider.articles.length,
          itemBuilder: (context, index) {
            final article = newsProvider.articles[index];
            return NewsItemWidget(article);
          },
        );
      },
    );
  }
}
