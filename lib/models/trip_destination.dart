import 'dart:convert';

class TripDestination {
  final int id;
  final String name;
  final String country;
  final String continent;
  final String description;
  final String imagePath;
  final String discount;

  // 해당 여행지에 속한 상품 리스트
  final List<TravelProduct> products;

  const TripDestination({
    required this.id,
    required this.name,
    required this.country,
    required this.continent,
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
      imagePath: json['imageUrl'].toString().replaceAll('localhost', '10.0.2.2'),
      discount: json['discount'],
      products: (json['products'] as List)
          .map((p) => TravelProduct.fromJson(p))
          .toList(),
    );
  }

  // 로컬 DB(SQLite) 저장을 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'continent': continent,
      'description': description,
      'imagePath': imagePath,
      'discount': discount,
      'products': jsonEncode(products.map((p) => p.toJson()).toList()), // 리스트를 JSON 문자열로 변환
    };
  }

  // 로컬 DB(SQLite) 데이터를 객체로 변환
  factory TripDestination.fromDbMap(Map<String, dynamic> map) {
    return TripDestination(
      id: map['id'],
      name: map['name'],
      country: map['country'],
      continent: map['continent'],
      description: map['description'],
      imagePath: map['imagePath'],
      discount: map['discount'],
      products: (jsonDecode(map['products']) as List)
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

  // JSON 인코딩을 위한 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'duration': duration,
      'price': price,
      'airline': airline,
      'hotel': hotel,
      'schedules': schedules,
    };
  }
}
