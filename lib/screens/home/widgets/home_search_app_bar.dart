// 홈 검색 AppBar: 검색 모드 전환과 검색 기록 제안을 담당하는 상단 바.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/services/search_history_service.dart';
import 'search_history_panel.dart';
import 'search_input_field.dart';

class HomeSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeSearchAppBar({super.key});

  @override
  State<HomeSearchAppBar> createState() => _HomeSearchAppBarState();

  // Scaffold에게 이 앱바의 높이가 '기본 앱바 높이(kToolbarHeight)'임을 알려준다.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeSearchAppBarState extends State<HomeSearchAppBar> {
  bool _isSearching = false;
  List<String> _searchHistory = [];
  final SearchHistoryService _historyService = SearchHistoryService();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // shared_preferences를 사용하여 저장된 검색 기록을 불러오는 함수
  Future<void> _loadSearchHistory() async {
    final history = await _historyService.loadHistory();
    if (!mounted) return;
    setState(() {
      _searchHistory = history;
    });
  }

  // 새로운 검색어를 shared_preferences에 저장하는 함수
  Future<void> _saveSearchTerm(String term) async {
    if (term.trim().isEmpty) return;
    await _historyService.saveTerm(term);
    await _refreshSearchHistory();
  }

  // 특정 검색어를 shared_preferences 기록에서 삭제하는 함수
  Future<void> _deleteSearchTerm(String term) async {
    await _historyService.deleteTerm(term);
    await _refreshSearchHistory();
  }

  Future<void> _refreshSearchHistory() async {
    final history = await _historyService.loadHistory();
    if (!mounted) return;
    setState(() {
      _searchHistory = history;
    });
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _saveSearchTerm(value);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('검색어: $value')));
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _isSearching
          ? Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return _searchHistory;
                }
                return _searchHistory.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _onSearchSubmitted(selection);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return SearchInputField(
                      controller: controller,
                      focusNode: focusNode,
                      onSubmitted: _onSearchSubmitted,
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return SearchHistoryPanel(
                  options: options,
                  onSelected: (selection) => _onSearchSubmitted(selection),
                  onDelete: _deleteSearchTerm,
                );
              },
            )
          : Text('Trip App', style: theme.appBarTheme.titleTextStyle),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          color: theme.appBarTheme.iconTheme?.color,
        ),
      ],
    );
  }
}
