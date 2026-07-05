import 'dart:math';

import 'package:flutter/material.dart';

import '../data/initial_sound_questions.dart';
import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';
import 'game_result_screen.dart';

class InitialSoundQuizScreen extends StatefulWidget {
  const InitialSoundQuizScreen({super.key});

  @override
  State<InitialSoundQuizScreen> createState() => _InitialSoundQuizScreenState();
}

class _InitialSoundQuizScreenState extends State<InitialSoundQuizScreen> {
  int _index = 0;
  int _score = 0;
  bool _answering = false;
  String _message = '초성에 맞는 낱말을 골라 주세요.';
  VisualFeedbackType _feedback = VisualFeedbackType.info;
  late final List<InitialSoundQuestion> _questions;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _questions = _pickQuestions();
    _options = _shuffledOptions(_questions.first);
  }

  List<InitialSoundQuestion> _pickQuestions() {
    final questions = List<InitialSoundQuestion>.of(initialSoundQuestionBank)
      ..shuffle(Random());
    return questions.take(5).toList(growable: false);
  }

  List<String> _shuffledOptions(InitialSoundQuestion question) {
    return (List<String>.from(
      question.options,
    )..shuffle()).toList(growable: false);
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
        _options = _shuffledOptions(_questions[_index]);
        _answering = false;
        _feedback = VisualFeedbackType.info;
        _message = '초성에 맞는 낱말을 골라 주세요.';
      });
      return;
    }

    activityStore.recordCompleted(
      title: '초성 퀴즈',
      summary: '${_questions.length}문제 중 $nextScore개 정답',
      score: nextScore,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: '초성 퀴즈 결과',
          message: nextScore >= 4 ? '낱말을 아주 잘 떠올리셨어요.' : '끝까지 잘 풀어 주셨습니다.',
          color: const Color(0xFF0E766E),
          gameTitle: '초성 퀴즈',
          restart: InitialSoundQuizScreen.new,
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
      title: '초성 퀴즈',
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
                  '초성: ${question.initial}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: Text(
                    '힌트: ${question.hint}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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
          for (final choice in _options) ...[
            LargeButton(
              label: choice,
              icon: Icons.check,
              color: const Color(0xFF0E766E),
              onPressed: _answering ? null : () => _answer(choice),
            ),
            if (choice != _options.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
