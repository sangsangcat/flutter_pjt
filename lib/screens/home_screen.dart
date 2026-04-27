import 'package:flutter/material.dart';
import 'package:flutter_pjt/providers/trip_provider.dart';
import 'package:flutter_pjt/screens/home/home_drawer_widget.dart';
import 'package:flutter_pjt/screens/home/home_grid_widget.dart';
import 'package:flutter_pjt/screens/home/home_middle_widget.dart';
import 'package:flutter_pjt/screens/home/home_top_widget.dart';
import 'package:provider/provider.dart';

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
      drawer: HomeDrawerWidget(),
      body: Column(
        children: [
          HomeTopWidget(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  HomeMiddleWidget(),

                  SizedBox(height: 16,),

                  //상위 어딘가에 추가된 앱의 상태 데이터 획득..
                  Expanded(
                    child: Consumer<TripProvider>(
                        builder: (context, tripProvider, child){
                          return HomeGridWidget(tripProvider.destination);
                        }
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