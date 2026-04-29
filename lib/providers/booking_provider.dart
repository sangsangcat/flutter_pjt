import 'dart:async';
import 'package:flutter/material.dart';
import '../models/booking.dart';
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
      _subscription = _firestoreService.getBookingsStream(_userId!).listen((list) {
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
