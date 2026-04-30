// 목적지 상세 화면: 추천 상품과 현지 뉴스를 탭으로 나눠 보여주는 컨테이너.
import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pjt/models/trip_destination.dart';
import 'widgets/news_list_widget.dart';
import 'widgets/product_list_widget.dart';

class DestinationScreen extends StatefulWidget {
  final TripDestination destination;

  const DestinationScreen(this.destination, {super.key});

  @override
  State<StatefulWidget> createState() {
    return DestinationScreenState();
  }
}

class DestinationScreenState extends State<DestinationScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    // 탭 변경 시 뉴스 데이터를 가져오는 기존 로직 유지
    tabController.addListener(() {
      if (tabController.index == 1 && tabController.indexIsChanging) {
        Provider.of<NewsProvider>(
          context,
          listen: false,
        ).fetchNews(widget.destination.country);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.name),
        // [수정] 색상/인디케이터는 AppTheme.tabBarTheme을 따르게 두어 테마 변경이 즉시 반영되도록 함
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: '추천 상품'),
            Tab(text: '현지 뉴스'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ProductListWidget(widget.destination),
          NewsListWidget(widget.destination.country),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
