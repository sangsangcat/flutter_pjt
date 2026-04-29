import 'dart:async';
import 'package:flutter/material.dart';
import '../models/trip_destination.dart';
import '../services/firestore_service.dart';

class WishlistProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  String? _userId;
  List<String> _wishlistProductKeys = [];
  StreamSubscription<List<String>>? _subscription;

  List<String> get wishlistProductKeys => _wishlistProductKeys;
  int get count => _wishlistProductKeys.length;

  /// UserProvider로부터 userId를 전달받아 스트림을 구독함
  void updateUserId(String? newUserId) {
    if (_userId == newUserId) return;
    
    _userId = newUserId;
    _subscription?.cancel();
    _wishlistProductKeys = [];

    if (_userId != null) {
      _subscription = _firestoreService.getProductWishlistStream(_userId!).listen((keys) {
        _wishlistProductKeys = keys;
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  /// 특정 상품이 관심상품인지 확인
  bool isWished(int destinationId, TravelProduct product) {
    final String productKey = "${destinationId}_${product.title.replaceAll(' ', '')}";
    return _wishlistProductKeys.contains(productKey);
  }

  /// 상품 단위 관심상품 토글
  Future<void> toggleWish(int destinationId, TravelProduct product) async {
    if (_userId == null) return;
    await _firestoreService.toggleProductWish(_userId!, destinationId, product);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
