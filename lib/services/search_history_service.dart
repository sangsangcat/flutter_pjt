import 'package:shared_preferences/shared_preferences.dart';

/// 검색 기록 저장소: SharedPreferences 읽기/쓰기만 담당한다.
class SearchHistoryService {
  static const String _storageKey = 'search_history';
  static const int _maxHistoryCount = 10;

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }

  Future<void> saveTerm(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await loadHistory();

    history.remove(trimmed);
    history.insert(0, trimmed);

    if (history.length > _maxHistoryCount) {
      history.removeRange(_maxHistoryCount, history.length);
    }

    await prefs.setStringList(_storageKey, history);
  }

  Future<void> deleteTerm(String term) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await loadHistory();

    history.remove(term);
    await prefs.setStringList(_storageKey, history);
  }
}
