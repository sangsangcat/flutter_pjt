import 'dart:async';
import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/trip_destination.dart';
import '../services/firestore_service.dart';

class BookingProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  String? _userId;
  List<Booking> _bookings = [];
  StreamSubscription<List<Booking>>? _subscription;

  List<Booking> get bookings => _bookings;
  int get count => _bookings.length;

  /// UserProvider로부터 userId를 전달받아 스트림을 구독하거나 해제함
  void updateUserId(String? newUserId) {
    if (_userId == newUserId) return;

    _userId = newUserId;
    _subscription?.cancel();
    _bookings = [];

    if (_userId != null) {
      // 새로운 유저의 예약 내역 실시간 구독
      _subscription = _firestoreService.getBookingsStream(_userId!).listen((
        list,
      ) {
        _bookings = list;
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  /// 예약 추가
  Future<void> addBooking(Booking booking) async {
    if (_userId == null) return;
    await _firestoreService.addBooking(_userId!, booking);
  }

  /// 상품 정보를 바탕으로 대기 상태 예약을 생성한다.
  Future<bool> createPendingBooking(
    TripDestination destination,
    TravelProduct product,
  ) async {
    if (_userId == null) return false;

    final newBooking = Booking(
      id: '',
      destinationId: destination.id,
      destinationName: destination.name,
      destinationImagePath: destination.imagePath,
      product: product,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await addBooking(newBooking);
    return true;
  }

  /// 예약 취소
  Future<bool> cancelBooking(String bookingId) async {
    if (_userId == null) return false;
    await _firestoreService.deleteBooking(_userId!, bookingId);
    return true;
  }

  /// 결제 완료 처리
  Future<bool> payBooking(String bookingId) async {
    if (_userId == null) return false;
    await _firestoreService.updateBookingStatus(_userId!, bookingId, 'paid');
    return true;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
