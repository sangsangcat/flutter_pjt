import 'package:flutter/material.dart';
import '../../models/trip_destination.dart';

class ProductItemWidget extends StatelessWidget {
  TripDestination destination;
  int index;

  ProductItemWidget(this.index, this.destination);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(destination.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text('${destination.name} 여행 상품 ${index + 1}'),
      subtitle: Text('${(index + 1) * 100} 만원부터'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }
}
