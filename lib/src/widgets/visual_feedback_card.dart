import 'package:flutter/material.dart';

enum VisualFeedbackType { success, failure, info }

class VisualFeedbackCard extends StatelessWidget {
  const VisualFeedbackCard({super.key, required this.type, this.message});

  final VisualFeedbackType type;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(type);
    final icon = _icon(type);
    final text = message ?? _message(type);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, size: 38, color: colors.foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _message(VisualFeedbackType type) {
    switch (type) {
      case VisualFeedbackType.success:
        return '잘하셨어요!';
      case VisualFeedbackType.failure:
        return '괜찮아요, 다시 해볼까요?';
      case VisualFeedbackType.info:
        return '천천히 눌러보세요';
    }
  }

  static IconData _icon(VisualFeedbackType type) {
    switch (type) {
      case VisualFeedbackType.success:
        return Icons.check_circle;
      case VisualFeedbackType.failure:
        return Icons.favorite;
      case VisualFeedbackType.info:
        return Icons.touch_app;
    }
  }

  static _FeedbackColors _colors(VisualFeedbackType type) {
    switch (type) {
      case VisualFeedbackType.success:
        return const _FeedbackColors(
          background: Color(0xFFE8F6EF),
          border: Color(0xFF1F7A5A),
          foreground: Color(0xFF14543D),
        );
      case VisualFeedbackType.failure:
        return const _FeedbackColors(
          background: Color(0xFFFFF0EA),
          border: Color(0xFFB54434),
          foreground: Color(0xFF8B2F22),
        );
      case VisualFeedbackType.info:
        return const _FeedbackColors(
          background: Color(0xFFEAF0FB),
          border: Color(0xFF4066A5),
          foreground: Color(0xFF2D4B7A),
        );
    }
  }
}

class _FeedbackColors {
  const _FeedbackColors({
    required this.background,
    required this.border,
    required this.foreground,
  });

  final Color background;
  final Color border;
  final Color foreground;
}
