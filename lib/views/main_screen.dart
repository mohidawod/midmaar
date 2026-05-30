import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/game_viewmodel.dart';
import '../viewmodels/main_viewmodel.dart';
import 'game_screen.dart';
import 'about_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<_TopicInfo> _topics = const [
    _TopicInfo('champions_league', 'دوري الأبطال', '🏆', Color(0xFF1F7A5C)),
    _TopicInfo('world_cup', 'كأس العالم', '🌍', Color(0xFF2667A8)),
    _TopicInfo('saudi_league', 'دوري روشن', '🇸🇦', Color(0xFF0E8A5A)),
    _TopicInfo('asia_cl', 'أبطال آسيا', '🌏', Color(0xFF764ABC)),
    _TopicInfo('africa_cl', 'أبطال أفريقيا', '🌍', Color(0xFFC06B2D)),
    _TopicInfo('gulf_cup', 'كأس الخليج', '🏆', Color(0xFF00897B)),
    _TopicInfo('copa_america', 'كوبا أمريكا', '🇦🇷', Color(0xFF3A6EA5)),
    _TopicInfo('premier_league', 'البريميرليج', '🏴', Color(0xFF7B1FA2)),
    _TopicInfo('ballon_dor', 'الكرة الذهبية', '🎈', Color(0xFFC79A19)),
    _TopicInfo('la_liga', 'لا ليغا', '🇪🇸', Color(0xFFC04747)),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 24,
        title: Text(
          'مضمار',
          style: TextStyle(
            color: Colors.greenAccent.shade400,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // زر معلومات التطبيق
          Tooltip(
            message: 'عن التطبيق',
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.greenAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
          ),
          // زر كتم الصوت
          Tooltip(
            message: vm.user.isMuted ? 'الصوت مكتوم' : 'الصوت مفعّل',
            child: IconButton(
              icon: Icon(
                vm.user.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: Colors.greenAccent,
              ),
              onPressed: vm.toggleMute,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF111716), Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر تحديك التالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أسئلة سريعة، وقت محدود، ونقاطك الأعلى تبقى محفوظة.',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                _ScoreBanner(bestScore: vm.user.bestScore),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: _topics.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.96,
                    ),
                    itemBuilder: (_, i) => _TopicCard(
                      topic: _topics[i],
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 260),
                            reverseTransitionDuration: const Duration(milliseconds: 220),
                            pageBuilder: (_, animation, __) => FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                              child: ChangeNotifierProvider(
                                create: (_) => GameViewModel(
                                  qRepo: context.read(),
                                  game: context.read(),
                                  timer: context.read(),
                                  anti: context.read(),
                                  sound: context.read(),
                                  mainVm: context.read(),
                                ),
                                child: GameScreen(topicId: _topics[i].id),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  final String bestScore;

  const _ScoreBanner({required this.bestScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2A22), Color(0xFF111111)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent.withValues(alpha: 0.12),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Colors.amberAccent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أفضل نتيجة',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  bestScore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'يتحدث تلقائيًا',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final _TopicInfo topic;
  final VoidCallback onTap;

  const _TopicCard({required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                topic.accent.withValues(alpha: 0.28),
                const Color(0xFF141414),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(topic.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const Spacer(),
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابدأ الجولة الآن',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicInfo {
  final String id;
  final String title;
  final String emoji;
  final Color accent;

  const _TopicInfo(this.id, this.title, this.emoji, this.accent);
}