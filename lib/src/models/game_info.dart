import 'package:flutter/material.dart';

class GameInfo {
  const GameInfo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.guide,
    required this.easyGuide,
    required this.icon,
    required this.color,
    required this.create,
  });

  final String title;
  final String subtitle;
  final String description;
  final String guide;
  final String easyGuide;
  final IconData icon;
  final Color color;
  final Widget Function() create;
}
