import 'package:flutter/material.dart';

/// 검색 기록 패널: 자동완성 목록과 삭제 액션을 담는 팝업 레이어.
class SearchHistoryPanel extends StatelessWidget {
  final Iterable<String> options;
  final ValueChanged<String> onSelected;
  final ValueChanged<String> onDelete;

  const SearchHistoryPanel({
    super.key,
    required this.options,
    required this.onSelected,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final optionsList = options.toList();

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
              itemCount: optionsList.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
              itemBuilder: (BuildContext context, int index) {
                final String option = optionsList[index];
                return ListTile(
                  leading: const Icon(Icons.history, size: 20),
                  title: Text(option, style: theme.textTheme.bodyMedium),
                  onTap: () => onSelected(option),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => onDelete(option),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
