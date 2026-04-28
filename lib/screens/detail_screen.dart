import 'package:flutter/material.dart';
import '../models/trip_destination.dart';
import './detail/product_list_widget.dart';

class DetailScreen extends StatefulWidget{
  final TripDestination destination;
  DetailScreen(this.destination);

  @override
  State<StatefulWidget> createState() {
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  late TabController tabController; //tab 화면 조정..

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
            Tab(text: '상품',),
            Tab(text: '뉴스',),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ProductListWidget(widget.destination),
          Text('뉴스'),
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