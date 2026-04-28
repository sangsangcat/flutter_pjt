import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/news_provider.dart';
import 'package:flutter_pjt/screens/detail/news_list_widget.dart';
import 'package:provider/provider.dart';
import '../models/trip_destination.dart';
import './detail/product_list_widget.dart';

class DetailScreen extends StatefulWidget {
  final TripDestination destination;

  DetailScreen(this.destination);

  @override
  State<StatefulWidget> createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (tabController.index == 1 && tabController.indexIsChanging) {
        // NewsProvider 내부에서 중복 호출 및 국가 변경 체크를 수행하므로
        // 여기서는 조건문 없이 호출
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: '상품'),
            Tab(text: '뉴스'),
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
    super.dispose();
    tabController.dispose();
  }
}
