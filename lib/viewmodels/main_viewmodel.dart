import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../services/sound_service.dart';  // 👈 أضف هذا السطر

class MainViewModel extends ChangeNotifier {
  final UserRepository _repo;
  final SoundService _sound;  // 👈 أضف هذا السطر
  UserModel _user = UserModel();

  MainViewModel(this._repo, this._sound);  // 👈 عدل هذا السطر

  Future<void> init() async {
    _user = await _repo.getUser();
    _sound.setMute(_user.isMuted);  // 👈 أضف هذا السطر (مهم جداً)
    notifyListeners();
  }

  UserModel get user => _user;

  Future<void> refreshUser() async {
    _user = await _repo.getUser();
    notifyListeners();
  }

  Future<void> addScore(int score) async {
    await _repo.addScore(score);
    await refreshUser();
  }

  Future<void> resetScore() async {
    await _repo.resetScore();
    await refreshUser();
  }

  Future<void> toggleMute() async {
    _user.isMuted = !_user.isMuted;
    await _repo.toggleMute(_user.isMuted);
    _sound.setMute(_user.isMuted);  // 👈 أضف هذا السطر
    notifyListeners();
  }
}