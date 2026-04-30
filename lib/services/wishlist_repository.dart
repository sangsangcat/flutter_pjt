import '../models/trip_destination.dart';
import 'firestore_service.dart';

// 관심상품 도메인의 Firestore 접근을 모아 Provider가 상태만 담당하게 한다.
class WishlistRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<String>> getProductWishlistStream(String userId) {
    return _firestoreService.getProductWishlistStream(userId);
  }

  Future<void> toggleProductWish(
    String userId,
    int destinationId,
    TravelProduct product,
  ) async {
    await _firestoreService.toggleProductWish(userId, destinationId, product);
  }
}
