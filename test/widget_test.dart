import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ncs_vita/main.dart';

void main() {
  testWidgets('exam tab shows a real practice screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('검정'));
    await tester.pumpAndSettle();

    expect(find.text('검정 모드'), findsOneWidget);
    expect(find.text('실전 시험 형태로 문제를 풀어보세요.'), findsOneWidget);
    expect(find.text('검정 시작'), findsOneWidget);
  });
}
