import 'package:flutter/material.dart';
import 'package:flutter_pjt/routes/app_routes.dart';
import '../../models/trip_destination.dart';
import 'home_grid_item_widget.dart';

class HomeGridWidget extends StatelessWidget {
  final List<TripDestination> destinations;

  const HomeGridWidget(this.destinations, {super.key});

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '해당 카테고리에 등록된 여행지가 없습니다.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, AppRoutes.detail, arguments: destination);
          },
          child: HomeGridItem(destination: destination),
        );
      },
    );
  }
}
