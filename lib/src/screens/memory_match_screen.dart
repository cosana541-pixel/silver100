import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../screens/game_result_screen.dart';
import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  final _random = Random();
  late List<_MemoryCard> _cards;
  int? _firstIndex;
  int? _secondIndex;
  int _tries = 0;
  bool _busy = false;
  VisualFeedbackType _feedback = VisualFeedbackType.info;
  late DateTime _startedAt;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  void _restart() {
    const words = ['해', '달', '꽃', '별', '산', '물'];
    final cards = [
      for (final word in words) _MemoryCard(word),
      for (final word in words) _MemoryCard(word),
    ]..shuffle(_random);

    setState(() {
      _cards = cards;
      _firstIndex = null;
      _secondIndex = null;
      _tries = 0;
      _busy = false;
      _feedback = VisualFeedbackType.info;
      _startedAt = DateTime.now();
    });
  }

  Future<void> _pick(int index) async {
    if (_busy || _cards[index].matched || _cards[index].open) return;

    setState(() {
      _cards[index].open = true;
      if (_firstIndex == null) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _tries += 1;
        _busy = true;
      }
    });

    if (_secondIndex == null) return;

    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;

    final first = _firstIndex!;
    final second = _secondIndex!;
    final matched = _cards[first].text == _cards[second].text;

    setState(() {
      _cards[first].matched = matched;
      _cards[second].matched = matched;
      _cards[first].open = matched;
      _cards[second].open = matched;
      _firstIndex = null;
      _secondIndex = null;
      _busy = false;
      _feedback = matched
          ? VisualFeedbackType.success
          : VisualFeedbackType.failure;
    });

    if (_cards.every((card) => card.matched)) {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      _showResult();
    } else if (matched) {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      if (!mounted) return;
      setState(() => _feedback = VisualFeedbackType.info);
    }
  }

  void _showResult() {
    final seconds = DateTime.now().difference(_startedAt).inSeconds;
    activityStore.recordCompleted(
      title: '신경쇠약',
      summary: '$seconds초, $_tries회 시도',
      score: 100000 - (seconds * 10) - _tries,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          title: '신경쇠약 성공',
          message: '모든 카드를 찾았습니다. 참 잘하셨어요.',
          color: Theme.of(context).colorScheme.primary,
          gameTitle: '신경쇠약',
          restart: MemoryMatchScreen.new,
          rows: [
            const ResultRow('성공 여부', '성공'),
            ResultRow('걸린 시간', '$seconds초'),
            ResultRow('시도 횟수', '$_tries회'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '신경쇠약',
      child: Column(
        children: [
          Text(
            '같은 글자 두 장을 찾아 주세요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '시도: $_tries회',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          VisualFeedbackCard(type: _feedback),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: _cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final card = _cards[index];
                return _MemoryTile(card: card, onTap: () => _pick(index));
              },
            ),
          ),
          LargeButton(
            label: '다시 하기',
            icon: Icons.refresh,
            color: Theme.of(context).colorScheme.primary,
            onPressed: _restart,
          ),
        ],
      ),
    );
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({required this.card, required this.onTap});

  final _MemoryCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visible = card.open || card.matched;

    return Semantics(
      button: true,
      label: visible ? '${card.text} 카드' : '닫힌 카드',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: visible ? Colors.white : const Color(0xFF1F7A5A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26, width: 2),
          ),
          child: Center(
            child: Text(
              visible ? card.text : '?',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: visible ? Colors.black87 : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MemoryCard {
  _MemoryCard(this.text);

  final String text;
  bool open = false;
  bool matched = false;
}
