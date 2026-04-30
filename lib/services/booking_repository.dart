import '../models/booking.dart';
import 'firestore_service.dart';

// 예약 도메인의 Firestore 접근을 모아 Provider가 상태/오케스트레이션만 담당하게 한다.
class BookingRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<Booking>> getBookingsStream(String userId) {
    return _firestoreService.getBookingsStream(userId);
  }

  Future<void> addBooking(String userId, Booking booking) async {
    await _firestoreService.addBooking(userId, booking);
  }

  Future<void> updateBookingStatus(
    String userId,
    String bookingId,
    String newStatus,
  ) async {
    await _firestoreService.updateBookingStatus(userId, bookingId, newStatus);
  }

  Future<void> deleteBooking(String userId, String bookingId) async {
    await _firestoreService.deleteBooking(userId, bookingId);
  }
}
