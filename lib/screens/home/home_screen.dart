// 홈 화면: 상단 배너, 필터, 목적지 그리드를 조립하는 메인 진입 화면.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/trip_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/home_drawer_widget.dart';
import 'widgets/home_grid_widget.dart';
import 'widgets/home_middle_widget.dart';
import 'widgets/home_search_app_bar.dart';
import 'widgets/home_top_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeSearchAppBar(),
      drawer: const HomeDrawerWidget(),
      body: Column(
        children: [
          const HomeTopWidget(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const HomeMiddleWidget(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Consumer<TripProvider>(
                      builder: (context, tripProvider, child) {
                        return HomeGridWidget(tripProvider.destination);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
