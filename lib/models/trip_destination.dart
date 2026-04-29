class TripDestination {
  final int id;
  final String name;
  final String country;
  final String continent; // 추가된 대륙 정보
  final String description;
  final String imagePath;
  final String discount;

  // 해당 여행지에 속한 상품 리스트
  final List<TravelProduct> products;

  const TripDestination({
    required this.id,
    required this.name,
    required this.country,
    required this.continent, // 추가된 대륙 정보
    required this.description,
    required this.imagePath,
    required this.discount,
    this.products = const [],
  });

  factory TripDestination.fromJson(Map<String, dynamic> json) {
    return TripDestination(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      continent: json['continent'] ?? 'Unknown',
      // JSON에서 대륙 정보 추출
      description: json['description'],
      // 서버에서 보낸 imageUrl을 사용하되, 에뮬레이터 환경이면 localhost를 10.0.2.2로 치환
      imagePath: json['imageUrl'].toString().replaceAll(
        'localhost',
        '10.0.2.2',
      ),
      discount: json['discount'],
      products: (json['products'] as List)
          .map((p) => TravelProduct.fromJson(p))
          .toList(),
    );
  }
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

  factory TravelProduct.fromJson(Map<String, dynamic> json) {
    return TravelProduct(
      title: json['title'],
      date: json['date'],
      duration: json['duration'],
      price: json['price'],
      airline: json['airline'],
      hotel: json['hotel'],
      schedules: List<String>.from(json['schedules']),
    );
  }
}
