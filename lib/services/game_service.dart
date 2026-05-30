class GameService {
  int calculateScore(bool correct, int timeLeft, int combo) {
    if (!correct) return 0;
    return 100 + (timeLeft * 5) + (combo * 10);
  }
}