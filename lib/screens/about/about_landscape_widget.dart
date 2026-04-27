import 'package:flutter/material.dart';
import 'build_feature_card.dart';

class AboutLandscapeWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade100,
                  ),
                  child: Icon(
                    Icons.travel_explore,
                    size: 80,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  'Trip App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '세계 여행을 계획하고 관리하는 최고의 앱',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24,),
                buildFeatureCard(
                  icon: Icons.flight,
                  title: '항공편 예약',
                  description: '전세계 항공편을 쉽게 검색하고 예약하세요.',
                ),
                SizedBox(height: 12,),
                buildFeatureCard(
                  icon: Icons.hotel,
                  title: '호텔 예약',
                  description: '최고의 호텔을 찾아 편안한 여행 즐기세요.',
                ),
                SizedBox(height: 12,),
                buildFeatureCard(
                  icon: Icons.map,
                  title: '여행 가이드',
                  description: '현지 정보와 추천 명소를 확인하세요.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}