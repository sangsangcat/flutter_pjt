class TripDestination {
  final String name;
  final String country;
  final String description;
  final String imagePath;
  final String discount;

  // 해당 여행지에 속한 상품 리스트
  final List<TravelProduct> products;

  const TripDestination({
    required this.name,
    required this.country,
    required this.description,
    required this.imagePath,
    required this.discount,
    this.products = const [],
  });
}

class TravelProduct {
  final String title;
  final String date;
  final String duration;
  final String price;
  final String airline;
  final String hotel;
  final List<String> schedules;

  TravelProduct({
    required this.title,
    required this.date,
    required this.duration,
    required this.price,
    required this.airline,
    required this.hotel,
    required this.schedules,
  });
}
