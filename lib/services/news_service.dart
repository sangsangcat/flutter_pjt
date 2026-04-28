//news 데이터 획득을 위한 네트워킹..
import 'dart:convert';

import 'package:flutter_pjt/models/news_article.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _baseUrl = 'http://newsapi.org/v2';
  static const String _apiKey = '028be63b17a7423faab20f180debf06f';

  //네트워킹을 위해서 호출되는 함수..
  Future<List<NewsArticle>> getNews(String query) async {
    try {
      final String searchKeyword = query.isEmpty ? 'travel' : query;

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything?q=$searchKeyword&page=1&pageSize=10&apiKey=$_apiKey',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        return articles
            .map((article) => NewsArticle.fromJson(article))
            .toList();
      } else {
        throw Exception('error news networking...1');
      }
    } catch (e) {
      print('error : $e');
      throw Exception('error news networking...2');
    }
  }
}
