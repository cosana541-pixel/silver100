import 'package:flutter/material.dart';

import '../models/game_info.dart';
import '../state/activity_store.dart';
import '../widgets/large_button.dart';
import '../widgets/senior_scaffold.dart';
import 'calculation_quiz_screen.dart';
import 'game_intro_screen.dart';
import 'initial_sound_quiz_screen.dart';
import 'memory_match_screen.dart';
import 'number_memory_screen.dart';
import 'ox_quiz_screen.dart';
import 'proverb_quiz_screen.dart';
import 'sequence_memory_screen.dart';
import 'settings_screen.dart';
import 'tutorial_screen.dart';
import 'word_chain_quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _games = [
    GameInfo(
      title: '신경쇠약',
      subtitle: '같은 그림 두 장 찾기',
      description: '카드를 두 장씩 뒤집어 같은 글자를 찾습니다.',
      guide: '카드를 하나 누르고, 또 하나를 누르세요. 같은 글자면 카드가 열려 있습니다.',
      easyGuide: '물음표 카드를 누르세요. 같은 글자를 찾으면 성공입니다.',
      icon: Icons.grid_view,
      color: Color(0xFF1F7A5A),
      create: MemoryMatchScreen.new,
    ),
    GameInfo(
      title: 'OX 퀴즈',
      subtitle: '맞으면 O, 틀리면 X',
      description: '짧은 문장을 보고 맞는지 고릅니다.',
      guide: '문장을 천천히 읽고 맞으면 O, 틀리면 X를 누르세요.',
      easyGuide: '맞는 말이면 O를 누르고, 틀린 말이면 X를 누르세요.',
      icon: Icons.quiz,
      color: Color(0xFFD58A1F),
      create: OxQuizScreen.new,
    ),
    GameInfo(
      title: '숫자 기억',
      subtitle: '보인 숫자를 다시 누르기',
      description: '잠깐 보인 숫자를 기억해서 다시 입력합니다.',
      guide: '숫자가 3초 동안 보입니다. 사라지면 같은 숫자를 차례대로 누르세요.',
      easyGuide: '처음에 보인 숫자를 마음속으로 읽고, 사라지면 그대로 누르세요.',
      icon: Icons.pin,
      color: Color(0xFF4066A5),
      create: NumberMemoryScreen.new,
    ),
    GameInfo(
      title: '속담 맞추기',
      subtitle: '빈칸에 맞는 말 고르기',
      description: '익숙한 속담의 빈칸을 보고 정답을 고릅니다.',
      guide: '속담을 천천히 읽고 빈칸에 들어갈 말을 보기에서 골라 주세요.',
      easyGuide: '빈칸 ___ 자리에 어울리는 말을 하나 누르세요.',
      icon: Icons.menu_book,
      color: Color(0xFF7A4E9A),
      create: ProverbQuizScreen.new,
    ),
    GameInfo(
      title: '초성 퀴즈',
      subtitle: '초성 보고 낱말 맞히기',
      description: '초성을 보고 보기 중 맞는 낱말을 고릅니다.',
      guide: '큰 초성을 천천히 보고, 어울리는 낱말을 보기에서 골라 주세요.',
      easyGuide: '예를 들어 ㅅㄱ는 사과처럼 읽을 수 있습니다.',
      icon: Icons.text_fields,
      color: Color(0xFF0E766E),
      create: InitialSoundQuizScreen.new,
    ),
    GameInfo(
      title: '끝말잇기 퀴즈',
      subtitle: '끝 글자로 시작하는 말 찾기',
      description: '앞 낱말의 마지막 글자로 시작하는 낱말을 고릅니다.',
      guide: '앞 낱말의 끝 글자를 보고, 그 글자로 시작하는 낱말을 눌러 주세요.',
      easyGuide: '예를 들어 사과의 끝 글자는 과입니다. 과자로 이어집니다.',
      icon: Icons.link,
      color: Color(0xFF9A5B13),
      create: WordChainQuizScreen.new,
    ),
    GameInfo(
      title: '순서 기억하기',
      subtitle: '보인 낱말을 차례대로 누르기',
      description: '잠깐 보인 생활 낱말의 순서를 기억합니다.',
      guide: '낱말이 잠깐 보입니다. 사라지면 같은 순서대로 눌러 주세요.',
      easyGuide: '사과, 바나나, 포도처럼 마음속으로 천천히 읽어 보세요.',
      icon: Icons.format_list_numbered,
      color: Color(0xFF7A4F24),
      create: SequenceMemoryScreen.new,
    ),
    GameInfo(
      title: '계산 퀴즈',
      subtitle: '쉬운 더하기와 빼기',
      description: '간단한 덧셈과 뺄셈의 답을 고릅니다.',
      guide: '문제를 천천히 계산하고 보기에서 맞는 답을 골라 주세요.',
      easyGuide: '손가락으로 세듯이 천천히 생각하셔도 좋습니다.',
      icon: Icons.calculate,
      color: Color(0xFF4F6F20),
      create: CalculationQuizScreen.new,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SeniorScaffold(
      title: '실버100',
      child: ListView(
        children: [
          Text(
            '오늘도 가볍게 두뇌 운동을 해볼까요?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '원하는 게임을 하나 골라 주세요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          LargeButton(
            label: '처음 하시는 분',
            icon: Icons.help_outline,
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    TutorialScreen(onDone: Navigator.of(context).pop),
              ),
            ),
          ),
          const SizedBox(height: 12),
          LargeButton(
            label: '설정',
            icon: Icons.settings,
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          const SizedBox(height: 22),
          AnimatedBuilder(
            animation: activityStore,
            builder: (context, _) => _TodayRecordPanel(
              played: activityStore.playedGames,
              completed: activityStore.completedGames,
              mostPlayed: activityStore.mostPlayedGame,
              message: activityStore.encouragement,
            ),
          ),
          const SizedBox(height: 22),
          for (final game in _games) ...[
            _GameCard(game: game),
            if (game != _games.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _TodayRecordPanel extends StatelessWidget {
  const _TodayRecordPanel({
    required this.played,
    required this.completed,
    required this.mostPlayed,
    required this.message,
  });

  final int played;
  final int completed;
  final String mostPlayed;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('오늘의 기록', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActivityNumber(label: '플레이', value: played),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActivityNumber(label: '완료', value: completed),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _RecordLine(label: '가장 많이 한 게임', value: mostPlayed),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _RecordLine extends StatelessWidget {
  const _RecordLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}

class _ActivityNumber extends StatelessWidget {
  const _ActivityNumber({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text('$value개', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});

  final GameInfo game;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: activityStore,
      builder: (context, _) {
        final stats = activityStore.statsFor(game.title);

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            key: ValueKey('game-card-${game.title}'),
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => GameIntroScreen(game: game)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: game.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(game.icon, size: 52, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              game.subtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              game.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 42),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _GameRecordSummary(stats: stats),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GameRecordSummary extends StatelessWidget {
  const _GameRecordSummary({required this.stats});

  final GameActivityStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘 ${stats.completed}회 완료',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '최고 기록: ${stats.bestSummary}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
