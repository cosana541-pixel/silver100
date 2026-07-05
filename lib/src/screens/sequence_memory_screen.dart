import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';
import 'game_result_screen.dart';

class SequenceMemoryScreen extends StatefulWidget {
  const SequenceMemoryScreen({super.key});

  @override
  State<SequenceMemoryScreen> createState() => _SequenceMemoryScreenState();
}

class _SequenceMemoryScreenState extends State<SequenceMemoryScreen> {
  static const _items = [
    '사과',
    '바나나',
    '포도',
    '수박',
    '꽃',
    '해',
    '달',
    '별',
    '나무',
    '우산',
  ];

  final _random = Random();
  Timer? _timer;
  int _level = 3;
  int _bestLevel = 0;
  bool _showing = true;
  bool _checking = false;
  List<String> _target = [];
  List<String> _choices = [];
  List<String> _input = [];
  String _message = '순서를 잘 봐 주세요.';
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
    final shuffled = List<String>.of(_items)..shuffle(_random);
    final target = shuffled.take(_level).toList(growable: false);
    final choices = List<String>.of(target)..shuffle(_random);

    setState(() {
      _target = target;
      _choices = choices;
      _input = [];
      _showing = true;
      _checking = false;
      _message = '순서를 잘 봐 주세요.';
      _feedback = VisualFeedbackType.info;
    });

    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showing = false;
          _message = '본 순서대로 눌러 주세요.';
        });
      }
    });
  }

  Future<void> _pick(String item) async {
    if (_showing || _checking || _input.contains(item)) return;

    final nextInput = [..._input, item];
    setState(() => _input = nextInput);
    if (nextInput.length < _target.length) return;

    final correct = _sameOrder(nextInput, _target);
    if (correct) _bestLevel = max(_bestLevel, _level);

    setState(() {
      _checking = true;
      _feedback = correct
          ? VisualFeedbackType.success
          : VisualFeedbackType.failure;
      _message = correct ? '순서를 잘 기억하셨어요!' : '괜찮아요. 여기까지 잘하셨습니다.';
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (correct && _level < 5) {
      setState(() => _level += 1);
      _newRound();
      return;
    }

    _showResult(correct);
  }

  bool _sameOrder(List<String> a, List<String> b) {
    for (var i = 0; i < b.length; i += 1) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _showResult(bool success) {
    final summary = success ? '$_bestLevel개 순서 성공' : '$_bestLevel개까지 성공';
    activityStore.recordCompleted(
      title: '순서 기억하기',
      summary: summary,
      score: _bestLevel,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: '순서 기억하기 결과',
          message: success ? '마지막 단계까지 성공하셨어요.' : '차분히 잘 기억해 주셨습니다.',
          color: const Color(0xFF7A4F24),
          gameTitle: '순서 기억하기',
          restart: SequenceMemoryScreen.new,
          rows: [
            ResultRow('도전 단계', '$_level개 순서'),
            ResultRow('성공 단계', _bestLevel == 0 ? '다음에 성공' : '$_bestLevel개 순서'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '순서 기억하기',
      child: Column(
        children: [
          Text(
            '단계: $_level개',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _SequencePanel(items: _showing ? _target : _input),
                const SizedBox(height: 14),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                VisualFeedbackCard(type: _feedback),
                const SizedBox(height: 16),
                if (!_showing)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final item in _choices)
                        _WordChoiceButton(
                          label: item,
                          selected: _input.contains(item),
                          onPressed: _checking ? null : () => _pick(item),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          LargeButton(
            label: _showing ? '다시 보여주기' : '처음부터 다시 보기',
            icon: Icons.refresh,
            color: const Color(0xFF7A4F24),
            onPressed: _checking ? null : _newRound,
          ),
        ],
      ),
    );
  }
}

class _SequencePanel extends StatelessWidget {
  const _SequencePanel({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26, width: 2),
      ),
      child: Center(
        child: Text(
          items.isEmpty ? ' ' : items.join(' -> '),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class _WordChoiceButton extends StatelessWidget {
  const _WordChoiceButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 142,
      child: ElevatedButton(
        onPressed: selected ? null : onPressed,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(68)),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
