import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:silver100/src/data/word_chain_questions.dart';

void main() {
  test('word chain bank has valid prompt, answer, and options', () {
    expect(wordChainQuestionBank, hasLength(60));

    for (final question in wordChainQuestionBank) {
      expect(question.promptWord.trim(), isNotEmpty);
      expect(question.lastChar.trim(), isNotEmpty);
      expect(question.answer.trim(), isNotEmpty);
      expect(question.options, hasLength(3));
      expect(question.options.toSet(), hasLength(3));
      expect(question.options, contains(question.answer));
      expect(question.promptWord.endsWith(question.lastChar), isTrue);
      expect(question.answer.startsWith(question.lastChar), isTrue);

      final correctLikeOptions = question.options
          .where((option) => option.startsWith(question.lastChar))
          .toList();
      expect(correctLikeOptions, [question.answer]);
    }
  });

  test('word chain options can appear in varied answer positions', () {
    final question = wordChainQuestionBank.first;
    final answerIndexes = <int>{};

    for (var seed = 0; seed < 30; seed += 1) {
      final options = List<String>.from(question.options)
        ..shuffle(Random(seed));
      answerIndexes.add(options.indexOf(question.answer));
    }

    expect(answerIndexes.length, greaterThan(1));
  });
}
