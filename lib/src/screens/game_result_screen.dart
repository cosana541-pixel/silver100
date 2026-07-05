import 'package:flutter/material.dart';

import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import '../widgets/visual_feedback_card.dart';

class GameResultScreen extends StatelessWidget {
  const GameResultScreen({
    super.key,
    required this.title,
    required this.message,
    required this.rows,
    required this.color,
    required this.gameTitle,
    required this.restart,
  });

  final String title;
  final String message;
  final List<ResultRow> rows;
  final Color color;
  final String gameTitle;
  final Widget Function() restart;

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '결과',
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Icon(Icons.emoji_events, size: 96, color: color),
                const SizedBox(height: 18),
                const VisualFeedbackCard(
                  type: VisualFeedbackType.success,
                  message: '축하합니다!',
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 14),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                for (final row in rows) _ResultLine(row: row),
              ],
            ),
          ),
          LargeButton(
            label: '다시 하기',
            icon: Icons.refresh,
            color: color,
            onPressed: () {
              activityStore.recordPlayed(gameTitle);
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => restart()));
            },
          ),
          const SizedBox(height: 12),
          LargeButton(
            label: '홈으로 가기',
            icon: Icons.home,
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}

class ResultRow {
  const ResultRow(this.label, this.value);

  final String label;
  final String value;
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.row});

  final ResultRow row;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text(row.value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
