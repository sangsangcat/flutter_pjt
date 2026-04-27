import 'package:flutter/material.dart';
import '../../models/trip_destination.dart';

//여행 상품 하나.. Item
class HomeGridItem extends StatelessWidget {
  final TripDestination destination;
  const HomeGridItem({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                destination.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              destination.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              destination.discount,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}