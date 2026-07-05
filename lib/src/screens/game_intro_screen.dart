import 'package:flutter/material.dart';

import '../models/game_info.dart';
import '../state/activity_store.dart';
import '../state/app_settings_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';

class GameIntroScreen extends StatelessWidget {
  const GameIntroScreen({super.key, required this.game});

  final GameInfo game;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettingsStore,
      builder: (context, _) => SeniorScaffold(
        title: game.title,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: game.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(game.icon, size: 64, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    game.subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    game.guide,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '연습하듯이 천천히 해도 됩니다.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (appSettingsStore.easyExplanation) ...[
                    const SizedBox(height: 16),
                    Text(
                      game.easyGuide,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '잘못 눌러도 괜찮습니다. 결과 화면에서 다시 할 수 있습니다.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            LargeButton(
              label: '시작하기',
              icon: Icons.play_arrow,
              color: game.color,
              onPressed: () {
                activityStore.recordPlayed(game.title);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => game.create()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
