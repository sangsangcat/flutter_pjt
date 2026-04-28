import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

//네트워킹 데이터가 앱의 상태 데이터로 가정해서..
class NewsProvider with ChangeNotifier {
  NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String? _error;

  List<NewsArticle> get articles => _articles;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _newsService.getNews();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
