enum Difficulty { easy, medium, hard }

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final Difficulty difficulty;
  final String topic;
  int usageCount;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.difficulty,
    required this.topic,
    this.usageCount = 0,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    final options = List<String>.from(data['options']);
    final correctIndex = data['correctIndex'] as int;

    if (options.length != 3) {
      throw FormatException(
        'Question ${data['id']} must have exactly 3 options, found ${options.length}.',
      );
    }

    if (correctIndex < 0 || correctIndex >= options.length) {
      throw FormatException(
        'Question ${data['id']} has invalid correctIndex $correctIndex.',
      );
    }

    return Question(
      id: data['id'],
      text: data['text'],
      options: options,
      correctIndex: correctIndex,
      difficulty: Difficulty.values.firstWhere((e) => e.name == data['difficulty']),
      topic: data['topic'],
      usageCount: data['usageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'text': text, 'options': options,
    'correctIndex': correctIndex, 'difficulty': difficulty.name,
    'topic': topic, 'usageCount': usageCount,
  };
}
