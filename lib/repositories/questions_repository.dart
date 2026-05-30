import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/topic_model.dart';

class QuestionsRepository {
  Future<Topic> getTopic(String topicId) async {
    final bytes = await rootBundle.load('assets/data/questions.json');
    final String response = utf8.decode(bytes.buffer.asUint8List());

    final data = json.decode(response) as Map<String, dynamic>;

    final topics = List<Map<String, dynamic>>.from(
      (data['topics'] as List).map((topic) => Map<String, dynamic>.from(topic as Map)),
    );

    final topicData = topics.firstWhere((topic) => topic['id'] == topicId);

    return Topic.fromJson(topicData);
  }
}