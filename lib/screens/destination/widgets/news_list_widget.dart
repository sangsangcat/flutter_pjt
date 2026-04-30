import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:flutter_pjt/screens/common/app_empty_state.dart';
import 'package:provider/provider.dart';
import 'news_item_widget.dart';

class NewsListWidget extends StatefulWidget {
  final String country;

  const NewsListWidget(this.country, {super.key});

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  @override
  void initState() {
    super.initState();
    // 뉴스 탭이 실제로 보여질 때 필요한 데이터를 요청해 화면 컨테이너 책임을 줄인다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NewsProvider>().fetchNews(widget.country);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              onPressed: () => newsProvider.fetchNews(widget.country),
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
