import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  bool _muted = false;

  void setMute(bool v) => _muted = v;

  Future<void> play(String name) async {
    if (_muted) return;
    try { await _player.play(AssetSource('sounds/$name.mp3')); } catch(_) {}
  }

  Future<void> preload() async {
    await _player.setReleaseMode(ReleaseMode.release);
  }
}