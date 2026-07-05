import 'package:flutter/material.dart';

class SeniorScaffold extends StatelessWidget {
  const SeniorScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        toolbarHeight: 72,
        centerTitle: true,
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    );
  }
}
