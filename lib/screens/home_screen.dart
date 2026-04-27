import 'package:flutter/material.dart';
import 'package:flutter_pjt/routes/home/home_middle_widget.dart';
import 'package:flutter_pjt/routes/home/home_top_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip App'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          HomeTopWidget(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  HomeMiddleWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}