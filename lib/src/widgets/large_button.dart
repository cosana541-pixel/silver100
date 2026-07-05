import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color == null ? null : Colors.white;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(68),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        backgroundColor: color,
        foregroundColor: foreground,
        disabledBackgroundColor: Colors.black12,
        disabledForegroundColor: Colors.black54,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 32),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
