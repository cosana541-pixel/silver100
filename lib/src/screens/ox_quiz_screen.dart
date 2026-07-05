import 'dart:math';

import 'package:flutter/material.dart';

import '../data/ox_questions.dart';
import '../screens/game_result_screen.dart';
import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';

class OxQuizScreen extends StatefulWidget {
  const OxQuizScreen({super.key});

  @override
  State<OxQuizScreen> createState() => _OxQuizScreenState();
}

class _OxQuizScreenState extends State<OxQuizScreen> {
  int _index = 0;
  int _score = 0;
  String _message = 'O 또는 X를 눌러 주세요.';
  VisualFeedbackType _feedback = VisualFeedbackType.info;
  bool _answering = false;
  late final List<OxQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _pickQuestions();
  }

  List<OxQuestion> _pickQuestions() {
    final questions = List<OxQuestion>.of(oxQuestionBank)..shuffle(Random());
    return questions.take(5).toList(growable: false);
  }

  Future<void> _answer(bool choice) async {
    if (_answering) return;

    final correct = _questions[_index].answer == choice;
    final nextScore = _score + (correct ? 1 : 0);

    setState(() {
      _answering = true;
      _feedback = correct
          ? VisualFeedbackType.success
          : VisualFeedbackType.failure;
      _message = correct ? '정답입니다!' : '괜찮아요. 다음 문제로 가요.';
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _score = nextScore;
        _index += 1;
        _feedback = VisualFeedbackType.info;
        _message = 'O 또는 X를 눌러 주세요.';
        _answering = false;
      });
      return;
    }

    activityStore.recordCompleted(
      title: 'OX 퀴즈',
      summary: '${_questions.length}문제 중 $nextScore개 정답',
      score: nextScore,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: 'OX 퀴즈 결과',
          message: '끝까지 풀어 주셨습니다.',
          color: Theme.of(context).colorScheme.secondary,
          gameTitle: 'OX 퀴즈',
          restart: OxQuizScreen.new,
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
      title: 'OX 퀴즈',
      child: Column(
        children: [
          Text(
            '문제 ${_index + 1} / ${_questions.length}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Text(
                  question.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 22),
                VisualFeedbackCard(type: _feedback),
              ],
            ),
          ),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: LargeButton(
                  label: 'O',
                  icon: Icons.circle_outlined,
                  color: const Color(0xFF1F7A5A),
                  onPressed: _answering ? null : () => _answer(true),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: LargeButton(
                  label: 'X',
                  icon: Icons.close,
                  color: const Color(0xFFB54434),
                  onPressed: _answering ? null : () => _answer(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
