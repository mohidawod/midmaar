import 'package:flutter/material.dart';

import 'main_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onReplay;

  const ResultsScreen({
    required this.score,
    required this.total,
    required this.onReplay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (score / (total * 150)).clamp(0.0, 1.0);
    final stars = pct > 0.8 ? '⭐⭐⭐' : pct > 0.5 ? '⭐⭐' : '⭐';
    final title = pct > 0.8
        ? 'أداء ممتاز'
        : pct > 0.5
            ? 'نتيجة قوية'
            : 'بداية جيدة';
    final subtitle = pct > 0.8
        ? 'واصل بنفس المستوى، أنت في قمة التحدي.'
        : pct > 0.5
            ? 'تبقى خطوة إضافية للوصول إلى القمة.'
            : 'جولة أخرى قد تغيّر كل شيء.';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      // إضافة resizeToAvoidBottomInset: false
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        // إضافة maintainBottomViewPadding: false
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              // إضافة physics لمنع التمرير غير المرغوب
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF18221C), Color(0xFF101010)],
                    ),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent.withValues(alpha: 0.10),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.amberAccent,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(stars, style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 10),
                      Text(
                        '$score',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 62,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'إجمالي النقاط',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onReplay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'إعادة اللعب',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.greenAccent),
                            foregroundColor: Colors.greenAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'تغيير الموضوع',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}