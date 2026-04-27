import 'package:flutter/material.dart';
import '../../models/trip_destination.dart';
import 'home_grid_item_widget.dart';

//데이터 개수 만큼 item 생성, grid 화면 구성..
class HomeGridWidget extends StatelessWidget {
  List<TripDestination> destinations;

  HomeGridWidget(this.destinations);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //한줄에 2개씩..
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: destinations.length,
      itemBuilder: (context, index){ //항목 구성을 위해 자동 호출..
        final destination = destinations[index]; //항목 데이터..
        return GestureDetector(
          onTap: (){ },
          child: HomeGridItem(destination: destination),
        );
      },
    );
  }
}
