import 'dart:math';

import 'package:flutter/material.dart';

import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';
import 'game_result_screen.dart';

class CalculationQuizScreen extends StatefulWidget {
  const CalculationQuizScreen({super.key});

  @override
  State<CalculationQuizScreen> createState() => _CalculationQuizScreenState();
}

class _CalculationQuizScreenState extends State<CalculationQuizScreen> {
  int _index = 0;
  int _score = 0;
  bool _answering = false;
  String _message = '알맞은 답을 골라 주세요.';
  VisualFeedbackType _feedback = VisualFeedbackType.info;
  late final List<_CalculationQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = List.generate(5, (_) => _CalculationQuestion.random());
  }

  Future<void> _answer(int choice) async {
    if (_answering) return;

    final question = _questions[_index];
    final correct = choice == question.answer;
    final nextScore = _score + (correct ? 1 : 0);

    setState(() {
      _answering = true;
      _feedback = correct
          ? VisualFeedbackType.success
          : VisualFeedbackType.failure;
      _message = correct ? '정답입니다!' : '괜찮아요. 답은 ${question.answer}입니다.';
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _score = nextScore;
        _index += 1;
        _answering = false;
        _feedback = VisualFeedbackType.info;
        _message = '알맞은 답을 골라 주세요.';
      });
      return;
    }

    activityStore.recordCompleted(
      title: '계산 퀴즈',
      summary: '${_questions.length}문제 중 $nextScore개 정답',
      score: nextScore,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: '계산 퀴즈 결과',
          message: nextScore >= 4 ? '차분하게 잘 계산하셨어요.' : '끝까지 잘 풀어 주셨습니다.',
          color: const Color(0xFF4F6F20),
          gameTitle: '계산 퀴즈',
          restart: CalculationQuizScreen.new,
          rows: [
            ResultRow('총 문제 수', '${_questions.length}문제'),
            ResultRow('정답 수', '$nextScore개'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_index];

    return SeniorScaffold(
      title: '계산 퀴즈',
      child: Column(
        children: [
          Text(
            '문제 ${_index + 1} / ${_questions.length}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                Text(
                  question.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                VisualFeedbackCard(type: _feedback),
                const SizedBox(height: 16),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          for (final choice in question.choices) ...[
            LargeButton(
              label: '$choice',
              icon: Icons.check,
              color: const Color(0xFF4F6F20),
              onPressed: _answering ? null : () => _answer(choice),
            ),
            if (choice != question.choices.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _CalculationQuestion {
  _CalculationQuestion({
    required this.text,
    required this.answer,
    required this.choices,
  });

  factory _CalculationQuestion.random() {
    final random = Random();
    final addition = random.nextBool();
    final a = random.nextInt(30) + 1;
    final b = random.nextInt(30) + 1;
    final left = addition ? a : max(a, b);
    final right = addition ? b : min(a, b);
    final answer = addition ? left + right : left - right;
    final choices = <int>{answer};

    while (choices.length < 3) {
      final offset = random.nextInt(9) - 4;
      final candidate = max(0, answer + (offset == 0 ? 5 : offset));
      choices.add(candidate);
    }

    return _CalculationQuestion(
      text: '$left ${addition ? '+' : '-'} $right = ?',
      answer: answer,
      choices: (choices.toList()..shuffle(random)).toList(growable: false),
    );
  }

  final String text;
  final int answer;
  final List<int> choices;
}
