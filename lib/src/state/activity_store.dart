import 'package:flutter/foundation.dart';

class ActivityStore extends ChangeNotifier {
  int _playedGames = 0;
  int _completedGames = 0;
  final Map<String, GameActivityStats> _gameStats = {};

  int get playedGames => _playedGames;
  int get completedGames => _completedGames;
  Map<String, GameActivityStats> get gameStats => Map.unmodifiable(_gameStats);

  String get mostPlayedGame {
    if (_gameStats.isEmpty || _playedGames == 0) return '아직 없음';

    GameActivityStats? best;
    for (final stats in _gameStats.values) {
      if (best == null || stats.played > best.played) {
        best = stats;
      }
    }
    return best == null || best.played == 0 ? '아직 없음' : best.title;
  }

  String get encouragement {
    if (_completedGames >= 3) return '오늘도 아주 꾸준히 잘하셨어요.';
    if (_completedGames >= 1) return '좋습니다. 한 번 더 가볍게 해볼까요?';
    if (_playedGames >= 1) return '천천히 하셔도 괜찮습니다.';
    return '오늘 첫 두뇌 운동을 시작해 보세요.';
  }

  GameActivityStats statsFor(String title) {
    return _gameStats[title] ?? GameActivityStats.empty(title);
  }

  void recordPlayed(String title) {
    _playedGames += 1;
    final stats = statsFor(title);
    _gameStats[title] = stats.copyWith(played: stats.played + 1);
    notifyListeners();
  }

  void recordCompleted({
    required String title,
    required String summary,
    int? score,
  }) {
    _completedGames += 1;
    final stats = statsFor(title);
    final shouldUpdateBest =
        score == null || stats.bestScore == null || score > stats.bestScore!;
    _gameStats[title] = stats.copyWith(
      completed: stats.completed + 1,
      bestScore: shouldUpdateBest ? score : stats.bestScore,
      bestSummary: shouldUpdateBest ? summary : stats.bestSummary,
    );
    notifyListeners();
  }
}

class GameActivityStats {
  const GameActivityStats({
    required this.title,
    required this.played,
    required this.completed,
    required this.bestSummary,
    required this.bestScore,
  });

  factory GameActivityStats.empty(String title) {
    return GameActivityStats(
      title: title,
      played: 0,
      completed: 0,
      bestSummary: '아직 기록 없음',
      bestScore: null,
    );
  }

  final String title;
  final int played;
  final int completed;
  final String bestSummary;
  final int? bestScore;

  GameActivityStats copyWith({
    int? played,
    int? completed,
    String? bestSummary,
    int? bestScore,
  }) {
    return GameActivityStats(
      title: title,
      played: played ?? this.played,
      completed: completed ?? this.completed,
      bestSummary: bestSummary ?? this.bestSummary,
      bestScore: bestScore ?? this.bestScore,
    );
  }
}

final activityStore = ActivityStore();
