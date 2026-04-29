import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import '../models/trip_destination.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- 관심상품 (Wishlist) 로직 ---

  /// 관심상품 토글 (특정 여행지의 특정 '상품' 단위로 처리)
  Future<void> toggleProductWish(
    String userId,
    int destinationId,
    TravelProduct product,
  ) async {
    // 상품 식별을 위해 목적지ID와 상품명을 조합한 키 생성 (공백 제거)
    final String productKey =
        "${destinationId}_${product.title.replaceAll(' ', '')}";

    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productKey);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'destinationId': destinationId,
        'productTitle': product.title,
        'price': product.price,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 사용자의 관심상품 키(productKey) 목록을 실시간으로 가져오는 스트림
  Stream<List<String>> getProductWishlistStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.id).toList();
        });
  }

  // --- 예약 (Booking) 로직 ---

  /// 새로운 예약 추가
  Future<void> addBooking(String userId, Booking booking) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .add(booking.toMap());
  }

  /// 예약 상태 업데이트 (결제 등)
  Future<void> updateBookingStatus(
    String userId,
    String bookingId,
    String newStatus,
  ) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .update({'status': newStatus});
  }

  /// 예약 삭제 (취소)
  Future<void> deleteBooking(String userId, String bookingId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .delete();
  }

  /// 사용자의 예약 내역을 실시간으로 가져오는 스트림
  Stream<List<Booking>> getBookingsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Booking.fromFirestore(doc))
              .toList();
        });
  }
}
