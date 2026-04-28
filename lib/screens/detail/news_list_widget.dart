import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'news_item_widget.dart';

class NewsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //앱의 상태로 화면 구성..
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (newsProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  '뉴스를 불러올 수 없습니다. \n ${newsProvider.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => newsProvider.fetchNews(),
                  child: Text('다시시도'),
                ),
              ],
            ),
          );
        }
        if (newsProvider.articles.isEmpty) {
          return Center(
            child: Text('뉴스가 없습니다.', style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: newsProvider.articles.length,
          itemBuilder: (context, index) {
            final article = newsProvider.articles[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: NewsItemWidget(article),
            );
          },
        );
      },
    );
  }
}
