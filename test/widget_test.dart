import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pjt/main.dart';

void main() {
  testWidgets('TripApp smoke test', (WidgetTester tester) async {
    // 앱 루트가 정상적으로 위젯 트리에 올라오는지만 확인하는 최소 테스트다.
    await tester.pumpWidget(const TripApp());

    expect(find.byType(TripApp), findsOneWidget);
  });
}
