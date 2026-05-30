import 'dart:math';
import '../models/question_model.dart';

class AntiRepetitionService {
  final Set<String> _used = {};
  final Random _random = Random();

  List<Question> prepare(List<Question> all) {
    _used.clear();
    final easy = all.where((q) => q.difficulty == Difficulty.easy).toList();
    final med = all.where((q) => q.difficulty == Difficulty.medium).toList();
    final hard = all.where((q) => q.difficulty == Difficulty.hard).toList();
    
    final ordered = [..._shuffle(easy), ..._shuffle(med), ..._shuffle(hard)];
    return _rebalanceCorrectAnswerPositions(ordered);
  }

  List<Question> _shuffle(List<Question> list) {
    list.sort((a, b) => a.usageCount.compareTo(b.usageCount));
    list.shuffle(_random);
    return list;
  }

  List<Question> _rebalanceCorrectAnswerPositions(List<Question> questions) {
    final balanced = <Question>[];
    final queue = <int>[];
    int? previousTarget;

    void refillQueue() {
      final cycle = [0, 1, 2]..shuffle(_random);
      if (previousTarget != null && cycle.first == previousTarget) {
        cycle.add(cycle.removeAt(0));
      }
      queue.addAll(cycle);
    }

    for (final question in questions) {
      if (queue.isEmpty) refillQueue();
      final targetIndex = queue.removeAt(0);
      previousTarget = targetIndex;
      balanced.add(_moveCorrectAnswerTo(question, targetIndex));
    }

    return balanced;
  }

  Question _moveCorrectAnswerTo(Question question, int targetIndex) {
    if (question.correctIndex == targetIndex) {
      return Question(
        id: question.id,
        text: question.text,
        options: List<String>.from(question.options),
        correctIndex: question.correctIndex,
        difficulty: question.difficulty,
        topic: question.topic,
        usageCount: question.usageCount,
      );
    }

    final correctOption = question.options[question.correctIndex];
    final distractors = List<String>.from(question.options)..removeAt(question.correctIndex);
    distractors.shuffle(_random);

    final newOptions = List<String>.filled(3, '');
    var distractorIndex = 0;
    for (var i = 0; i < newOptions.length; i++) {
      if (i == targetIndex) {
        newOptions[i] = correctOption;
      } else {
        newOptions[i] = distractors[distractorIndex++];
      }
    }

    return Question(
      id: question.id,
      text: question.text,
      options: newOptions,
      correctIndex: targetIndex,
      difficulty: question.difficulty,
      topic: question.topic,
      usageCount: question.usageCount,
    );
  }

  void markUsed(String id) => _used.add(id);
}
