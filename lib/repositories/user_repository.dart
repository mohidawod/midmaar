import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const _bestKey = 'midmaar_best';
  static const _muteKey = 'midmaar_muted';

  Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return UserModel(
      bestScore: prefs.getString(_bestKey) ?? '0',
      isMuted: prefs.getBool(_muteKey) ?? false,
    );
  }

  Future<void> addScore(int newPoints) async {
    final prefs = await SharedPreferences.getInstance();
    final currentScore = int.parse(prefs.getString(_bestKey) ?? '0');
    final totalScore = currentScore + newPoints;
    await prefs.setString(_bestKey, totalScore.toString());
  }

  Future<void> resetScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bestKey, '0');
  }

  Future<void> toggleMute(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_muteKey, value);
  }
}