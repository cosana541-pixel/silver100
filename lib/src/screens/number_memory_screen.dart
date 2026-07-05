import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../screens/game_result_screen.dart';
import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';

class NumberMemoryScreen extends StatefulWidget {
  const NumberMemoryScreen({super.key});

  @override
  State<NumberMemoryScreen> createState() => _NumberMemoryScreenState();
}

class _NumberMemoryScreenState extends State<NumberMemoryScreen> {
  final _random = Random();
  Timer? _timer;
  String _target = '';
  String _input = '';
  final int _level = 3;
  int _bestLevel = 0;
  bool _showing = true;
  bool _checking = false;
  String _message = '숫자를 잘 봐 주세요.';
  VisualFeedbackType _feedback = VisualFeedbackType.info;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newRound() {
    _timer?.cancel();
    final next = List.generate(_level, (_) => _random.nextInt(10)).join();
    setState(() {
      _target = next;
      _input = '';
      _showing = true;
      _checking = false;
      _message = '숫자를 잘 봐 주세요.';
      _feedback = VisualFeedbackType.info;
    });
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showing = false;
          _message = '기억한 숫자를 눌러 주세요.';
        });
      }
    });
  }

  Future<void> _pressDigit(int digit) async {
    if (_showing || _checking || _input.length >= _target.length) return;

    final candidate = '$_input$digit';
    setState(() => _input = candidate);

    if (candidate.length < _target.length) return;

    final correct = candidate == _target;
    final attemptedLevel = _level;

    if (correct) {
      _bestLevel = max(_bestLevel, attemptedLevel);
    }
    final bestText = _bestLevel == 0 ? '아직 없음' : '$_bestLevel자리';

    setState(() {
      _checking = true;
      _feedback = correct
          ? VisualFeedbackType.success
          : VisualFeedbackType.failure;
      _message = correct ? '잘하셨어요!' : '괜찮아요, 다시 해볼까요?';
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    activityStore.recordCompleted(
      title: '숫자 기억',
      summary: correct ? '$attemptedLevel자리 성공' : '$attemptedLevel자리 도전',
      score: correct ? attemptedLevel : attemptedLevel - 1,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: '숫자 기억 결과',
          message: correct ? '정확하게 기억하셨어요.' : '충분히 잘하셨습니다. 다시 해볼까요?',
          color: Theme.of(context).colorScheme.tertiary,
          gameTitle: '숫자 기억',
          restart: NumberMemoryScreen.new,
          rows: [
            ResultRow('도전 단계', '$attemptedLevel자리'),
            ResultRow('성공 단계', correct ? '$attemptedLevel자리' : '다음에 성공'),
            ResultRow('최고 단계', bestText),
          ],
        ),
      ),
    );
  }

  void _erase() {
    if (_showing || _checking || _input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final complete = !_showing && _input.length == _target.length;

    return SeniorScaffold(
      title: '숫자 기억',
      child: Column(
        children: [
          Text(
            '단계: $_level자리',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26, width: 2),
            ),
            child: Text(
              _showing ? _target : (_input.isEmpty ? ' ' : _input),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          VisualFeedbackCard(type: _feedback),
          const SizedBox(height: 18),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: [
                for (var i = 1; i <= 9; i++) _DigitButton(i, _pressDigit),
                _ActionKey(icon: Icons.backspace, onPressed: _erase),
                _DigitButton(0, _pressDigit),
                _ActionKey(icon: Icons.refresh, onPressed: _newRound),
              ],
            ),
          ),
          LargeButton(
            label: complete ? '다음 문제' : '새 숫자 보기',
            icon: complete ? Icons.arrow_forward : Icons.refresh,
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: _checking ? null : _newRound,
          ),
        ],
      ),
    );
  }
}

class _DigitButton extends StatelessWidget {
  const _DigitButton(this.digit, this.onPressed);

  final int digit;
  final void Function(int digit) onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(digit),
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(64)),
      child: Text(
        '$digit',
        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _ActionKey extends StatelessWidget {
  const _ActionKey({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(64)),
      child: Icon(icon, size: 34),
    );
  }
}
