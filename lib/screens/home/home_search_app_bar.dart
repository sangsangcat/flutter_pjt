import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  // shared_preferences를 사용하여 저장된 검색 기록을 불러오는 함수
  Future<void> _loadSearchHistory() async {
    // SharedPreferences 인스턴스를 획득 (비동기 처리)
    final prefs = await SharedPreferences.getInstance();
    // 'search_history' 키로 저장된 문자열 리스트를 가져옴 (없으면 빈 리스트)
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  // 새로운 검색어를 shared_preferences에 저장하는 함수
  Future<void> _saveSearchTerm(String term) async {
    if (term.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 중복된 검색어가 있다면 먼저 제거 (최신순 정렬을 위해)
      _searchHistory.remove(term);
      // 리스트의 가장 앞에 새로운 검색어 추가
      _searchHistory.insert(0, term);
      // 기록을 최대 10개로 제한
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }
    });
    // 업데이트된 리스트를 'search_history' 키로 영구 저장
    await prefs.setStringList('search_history', _searchHistory);
  }

  // 특정 검색어를 shared_preferences 기록에서 삭제하는 함수
  Future<void> _deleteSearchTerm(String term) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 메모리 상의 리스트에서 해당 검색어 제거
      _searchHistory.remove(term);
    });
    // 변경된 리스트를 다시 저장하여 데이터 동기화
    await prefs.setStringList('search_history', _searchHistory);
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
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      // 테마의 텍스트 스타일 적용
                      style: theme.textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: '어디로 떠나고 싶으신가요?',
                        // InputDecorationTheme이 정의되어 있어 상세 설정 생략 가능
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                      onSubmitted: (value) {
                        _onSearchSubmitted(value);
                      },
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Material(
                      elevation: 8.0,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 64,
                        color: theme.cardTheme.color,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: theme.dividerColor.withValues(alpha: 0.1),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return ListTile(
                              leading: const Icon(Icons.history, size: 20),
                              title: Text(option, style: theme.textTheme.bodyMedium),
                              onTap: () => onSelected(option),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  _deleteSearchTerm(option);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Text(
              'Trip App',
              style: theme.appBarTheme.titleTextStyle,
            ),
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
        if (!_isSearching)
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.notifications_none),
            color: theme.appBarTheme.iconTheme?.color,
          ),
      ],
    );
  }
}
