import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:silver100/src/data/initial_sound_questions.dart';

void main() {
  test('initial sound bank has clear hints and three options', () {
    expect(initialSoundQuestionBank, hasLength(60));

    for (final question in initialSoundQuestionBank) {
      expect(question.initial.trim(), isNotEmpty);
      expect(question.answer.trim(), isNotEmpty);
      expect(question.hint.trim(), isNotEmpty);
      expect(question.options, hasLength(3));
      expect(question.options.toSet(), hasLength(3));
      expect(question.options, contains(question.answer));
    }
  });

  test('initial sound options can appear in varied answer positions', () {
    final question = initialSoundQuestionBank.first;
    final answerIndexes = <int>{};

    for (var seed = 0; seed < 30; seed += 1) {
      final options = List<String>.from(question.options)
        ..shuffle(Random(seed));
      answerIndexes.add(options.indexOf(question.answer));
    }

    expect(answerIndexes.length, greaterThan(1));
  });
}
