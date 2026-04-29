import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trip_provider.dart';

class HomeMiddleWidget extends StatelessWidget {
  const HomeMiddleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    
    // 카테고리 목록 (데이터가 없는 대륙 추가)
    final continents = [
      {'label': '전체', 'value': 'All'},
      {'label': '유럽', 'value': 'Europe'},
      {'label': '아시아', 'value': 'Asia'},
      {'label': '오세아니아', 'value': 'Oceania'},
      {'label': '북미', 'value': 'North America'},
      {'label': '남미', 'value': 'South America'},
      {'label': '아프리카', 'value': 'Africa'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '인기 여행지',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: continents.map((continent) {
              final isSelected = tripProvider.selectedContinent == continent['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(continent['label']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      // 서버 요청 없이 로컬 상태만 변경
                      tripProvider.setContinent(continent['value']!);
                    }
                  },
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
