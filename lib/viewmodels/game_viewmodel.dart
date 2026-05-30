import 'package:flutter/foundation.dart';

import '../models/question_model.dart';
import '../repositories/questions_repository.dart';
import '../services/anti_repetition_service.dart';
import '../services/game_service.dart';
import '../services/sound_service.dart';
import '../services/timer_service.dart';
import 'main_viewmodel.dart';

class GameViewModel extends ChangeNotifier {
  final QuestionsRepository _qRepo;
  final GameService _game;
  final TimerService _timer;
  final AntiRepetitionService _anti;
  final SoundService _sound;
  final MainViewModel _mainVm;

  List<Question> _questions = [];
  int _idx = 0;
  int _score = 0;
  int _combo = 0;
  bool _ended = false;
  bool _loading = false;
  int? _selectedIndex;
  bool _isCorrect = false;
  String? _error;

  GameViewModel({
    required QuestionsRepository qRepo,
    required GameService game,
    required TimerService timer,
    required AntiRepetitionService anti,
    required SoundService sound,
    required MainViewModel mainVm,
  })  : _qRepo = qRepo,
        _game = game,
        _timer = timer,
        _anti = anti,
        _sound = sound,
        _mainVm = mainVm;

  Future<void> start(String topicId) async {
    _loading = true;
    _error = null;
    _questions = [];
    _idx = 0;
    _score = 0;
    _combo = 0;
    _ended = false;
    _selectedIndex = null;
    _isCorrect = false;
    _timer.stop();
    notifyListeners();

    try {
      final topic = await _qRepo.getTopic(topicId);
      _questions = _anti.prepare(topic.questions);

      if (_questions.isEmpty) {
        _error = 'لا توجد أسئلة متاحة لهذا الموضوع.';
        _loading = false;
        notifyListeners();
        return;
      }

      _loading = false;
      _next();
    } catch (e, st) {
      debugPrint('Game start failed for $topicId: $e');
      debugPrintStack(stackTrace: st);
      _loading = false;
      _error = kDebugMode
          ? 'تعذر تحميل الأسئلة:\n$e'
          : 'تعذر تحميل الأسئلة. حاول مرة أخرى.';
      notifyListeners();
    }
  }

  void _next() {
    if (_idx >= _questions.length) {
      _end();
      return;
    }

    _selectedIndex = null;
    _isCorrect = false;
    _timer.start(
      onTick: (_) => notifyListeners(),
      onEnd: () => _submit(-1),
    );
    notifyListeners();
  }

  void submit(int idx) => _submit(idx);

  void _submit(int idx) {
    if (_selectedIndex != null) return;

    final q = _questions[_idx];
    _selectedIndex = idx;
    _isCorrect = idx == q.correctIndex;
    _anti.markUsed(q.id);

    if (_isCorrect) {
      _combo++;
      _score += _game.calculateScore(true, _timer.remaining, _combo);
      _sound.play('correct');
    } else {
      _combo = 0;
      _sound.play('wrong');
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      _idx++;
      notifyListeners();
      _next();
    });
  }

  Future<void> _end() async {
    _timer.stop();
    _ended = true;
    await _mainVm.addScore(_score);  // 👈 غيرنا هنا
    _sound.play('win');
    notifyListeners();
  }

  Question? get q => _idx < _questions.length ? _questions[_idx] : null;
  int get progress => _idx;
  int get total => _questions.length;
  int get score => _score;
  int get combo => _combo;
  bool get ended => _ended;
  bool get loading => _loading;
  int? get sel => _selectedIndex;
  bool get correct => _isCorrect;
  int get timer => _timer.remaining;
  String? get error => _error;
}