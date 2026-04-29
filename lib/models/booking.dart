import 'package:cloud_firestore/cloud_firestore.dart';
import 'trip_destination.dart';

/// 사용자의 예약 정보를 담는 모델 클래스
class Booking {
  final String id; // Firestore 문서 ID
  final int destinationId; // 여행지 ID (TripDestination.id)
  final String destinationName; // 여행지 이름 (UI 표시용 스냅샷)
  final String destinationImagePath; // 여행지 이미지 (UI 표시용 스냅샷)
  final TravelProduct product; // 예약한 구체적인 상품 정보
  final String status; // 상태: 'pending' (대기), 'paid' (결제 완료), 'cancelled' (취소)
  final DateTime createdAt; // 예약 생성 일시

  Booking({
    required this.id,
    required this.destinationId,
    required this.destinationName,
    required this.destinationImagePath,
    required this.product,
    required this.status,
    required this.createdAt,
  });

  /// Firestore 데이터를 객체로 변환
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      destinationId: data['destinationId'],
      destinationName: data['destinationName'],
      destinationImagePath: data['destinationImagePath'],
      product: TravelProduct.fromJson(data['product']),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// 객체를 Firestore에 저장하기 위한 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'destinationId': destinationId,
      'destinationName': destinationName,
      'destinationImagePath': destinationImagePath,
      'product': product.toJson(),
      'status': status,
      'createdAt': FieldValue.serverTimestamp(), // 서버 시간을 기준으로 저장
    };
  }
}
