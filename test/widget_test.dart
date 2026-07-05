import 'package:flutter_test/flutter_test.dart';

import 'package:silver100/src/app.dart';

void main() {
  testWidgets('tutorial opens home with eight games', (tester) async {
    await tester.pumpWidget(const Silver100App());

    expect(find.text('실버100'), findsOneWidget);
    expect(find.text('게임을 고르세요'), findsOneWidget);

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('홈으로 가기').last);
    await tester.pumpAndSettle();

    expect(find.text('처음 하시는 분'), findsOneWidget);
    expect(find.text('설정'), findsOneWidget);
    expect(find.text('오늘의 기록'), findsOneWidget);
    expect(find.text('가장 많이 한 게임'), findsOneWidget);
    expect(find.text('0개'), findsWidgets);

    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();
    expect(find.text('글씨 크기'), findsOneWidget);
    expect(find.text('글씨 크게'), findsOneWidget);
    expect(find.text('글씨 아주 크게'), findsOneWidget);
    expect(find.text('쉬운 설명 보기'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('신경쇠약'), 180);
    expect(find.text('신경쇠약'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('OX 퀴즈'), 180);
    expect(find.text('OX 퀴즈'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('숫자 기억'), 180);
    expect(find.text('숫자 기억'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('속담 맞추기'), 180);
    expect(find.text('속담 맞추기'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('초성 퀴즈'), 180);
    expect(find.text('초성 퀴즈'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('끝말잇기 퀴즈'), 180);
    expect(find.text('끝말잇기 퀴즈'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('순서 기억하기'), 180);
    expect(find.text('순서 기억하기'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('계산 퀴즈'), 180);
    expect(find.text('계산 퀴즈'), findsOneWidget);
  });

  testWidgets('new game cards open the intro screen', (tester) async {
    await tester.pumpWidget(const Silver100App());
    await _finishTutorial(tester);

    for (final title in ['초성 퀴즈', '끝말잇기 퀴즈', '순서 기억하기', '계산 퀴즈']) {
      await tester.scrollUntilVisible(find.text(title), 180);
      await tester.tap(find.text(title).first);
      await tester.pumpAndSettle();

      expect(find.text('시작하기'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}

Future<void> _finishTutorial(WidgetTester tester) async {
  await tester.tap(find.text('다음'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('다음'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('다음'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('홈으로 가기').last);
  await tester.pumpAndSettle();
}
