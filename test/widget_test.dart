import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:starter_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // アプリをビルドしてフレームをトリガーします
    await tester.pumpWidget(MyApp()); // 'const' を削除します

    // カウンターが 0 から始まっていることを確認します
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // '+' アイコンをタップしてフレームをトリガーします
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // カウンターがインクリメントされたことを確認します
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
