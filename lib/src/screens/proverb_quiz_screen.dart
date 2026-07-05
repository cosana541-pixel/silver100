import 'dart:math';

import 'package:flutter/material.dart';

import '../data/proverb_questions.dart';
import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';
import 'game_result_screen.dart';

class ProverbQuizScreen extends StatefulWidget {
  const ProverbQuizScreen({super.key});

  @override
  State<ProverbQuizScreen> createState() => _ProverbQuizScreenState();
}

class _ProverbQuizScreenState extends State<ProverbQuizScreen> {
  int _index = 0;
  int _score = 0;
  bool _answering = false;
  String _message = '알맞은 말을 골라 주세요.';
  VisualFeedbackType _feedback = VisualFeedbackType.info;
  late final List<ProverbQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _pickQuestions();
  }

  List<ProverbQuestion> _pickQuestions() {
    final questions = List<ProverbQuestion>.of(proverbQuestionBank)
      ..shuffle(Random());
    return questions.take(5).toList(growable: false);
  }

  Future<void> _answer(String choice) async {
    if (_answering) return;

    final question = _questions[_index];
    final correct = choice == question.answer;
    final nextScore = _score + (correct ? 1 : 0);

    setState(() {
      _answering = true;
      _feedback = correct
          ? VisualFeedbackType.success
          : VisualFeedbackType.failure;
      _message = correct ? '정답입니다!' : '괜찮아요. 정답은 ${question.answer}입니다.';
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _score = nextScore;
        _index += 1;
        _answering = false;
        _feedback = VisualFeedbackType.info;
        _message = '알맞은 말을 골라 주세요.';
      });
      return;
    }

    activityStore.recordCompleted(
      title: '속담 맞추기',
      summary: '${_questions.length}문제 중 $nextScore개 정답',
      score: nextScore,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: '속담 맞추기 결과',
          message: nextScore >= 4 ? '속담을 아주 잘 기억하셨어요.' : '끝까지 잘 풀어 주셨습니다.',
          color: Theme.of(context).colorScheme.primary,
          gameTitle: '속담 맞추기',
          restart: ProverbQuizScreen.new,
          rows: [
            ResultRow('총 문제 수', '${_questions.length}문제'),
            ResultRow('정답 수', '$nextScore개'),
            const ResultRow('응원 문구', '오늘도 잘하셨어요'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_index];

    return SeniorScaffold(
      title: '속담 맞추기',
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
              label: choice,
              icon: Icons.check,
              color: Theme.of(context).colorScheme.primary,
              onPressed: _answering ? null : () => _answer(choice),
            ),
            if (choice != question.choices.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
