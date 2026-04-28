import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String? _error;
  String? _currentCountry; // 현재 로드된 뉴스 국가명 저장

  List<NewsArticle> get articles => _articles;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchNews(String query) async {
    // 이미 해당 국가의 데이터가 있고, 에러가 없는 상태라면 중복 호출 방지
    if (_currentCountry == query && _articles.isNotEmpty && _error == null) {
      return;
    }

    _isLoading = true;
    _currentCountry = query; // 현재 국가 저장
    _articles = [];
    _error = null;
    notifyListeners();

    try {
      _articles = await _newsService.getNews(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
