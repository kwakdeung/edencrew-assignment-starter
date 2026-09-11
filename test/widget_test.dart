import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edencrew_assignment_starter/main.dart';

void main() {
  testWidgets('앱이 다크 테마로 렌더링되고 하단 탭(관심/검색)이 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const EdencrewAssignmentApp());
    await tester.pump();

    expect(find.text('관심'), findsWidgets);
    expect(find.text('검색'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
      Brightness.dark,
    );
  });

  testWidgets('하단 탭을 누르면 검색 화면으로 전환된다', (WidgetTester tester) async {
    await tester.pumpWidget(const EdencrewAssignmentApp());
    await tester.pump();

    await tester.tap(find.text('검색').last);
    await tester.pump();

    expect(find.text('종목을 검색해 보세요'), findsOneWidget);
  });
}
