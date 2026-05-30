import 'question_model.dart';

class Topic {
  final String id;
  final String name;
  final List<Question> questions;

  Topic({required this.id, required this.name, required this.questions});

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'],
    name: json['name'],
    questions: (json['questions'] as List)
        .map((q) => Question.fromJson(Map<String, dynamic>.from(q as Map)))
        .toList(),
  );
}
