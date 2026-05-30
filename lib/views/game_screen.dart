import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/game_viewmodel.dart';
import 'results_screen.dart';

class GameScreen extends StatefulWidget {
  final String topicId;

  const GameScreen({required this.topicId, super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GameViewModel>().start(widget.topicId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Consumer<GameViewModel>(
        builder: (context, vm, _) {
          if (vm.ended) {
            return ResultsScreen(
              score: vm.score,
              total: vm.total,
              onReplay: () => vm.start(widget.topicId),
            );
          }

          if (vm.loading) {
            return const _LoadingState();
          }

          if (vm.error != null) {
            return _ErrorState(
              message: vm.error!,
              onRetry: () => vm.start(widget.topicId),
            );
          }

          if (vm.q == null) {
            return const Center(
              child: Text(
                'لا يوجد سؤال متاح الآن.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
                    child: Column(
                      children: [
                        _TopHud(vm: vm),
                        const SizedBox(height: 24),
                        _TimerDial(seconds: vm.timer),
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: vm.combo > 1
                              ? Container(
                                  key: ValueKey(vm.combo),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '🔥 Combo x${vm.combo}',
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : const SizedBox(key: ValueKey('empty'), height: 36),
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: Container(
                            key: ValueKey(vm.q!.id),
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              color: const Color(0xFF151515),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            child: Text(
                              vm.q!.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...vm.q!.options.asMap().entries.map(
                              (e) => _Option(
                                idx: e.key,
                                text: e.value,
                                vm: vm,
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TopHud extends StatelessWidget {
  final GameViewModel vm;

  const _TopHud({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التقدم',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vm.progress + 1} / ${vm.total}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'النقاط',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '⚡ ${vm.score}',
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimerDial extends StatelessWidget {
  final int seconds;

  const _TimerDial({required this.seconds});

  @override
  Widget build(BuildContext context) {
    final color = seconds <= 3 ? Colors.redAccent : Colors.greenAccent;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 102,
              height: 102,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: seconds / 10),
                duration: const Duration(milliseconds: 250),
                builder: (_, value, __) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: 7,
                  backgroundColor: Colors.grey[850],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$seconds',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'ثانية',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'الوقت المتبقي',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final int idx;
  final String text;
  final GameViewModel vm;

  const _Option({
    required this.idx,
    required this.text,
    required this.vm,
  });

  Color get _background {
    if (vm.sel == null) return const Color(0xFF171717);
    if (idx == vm.q!.correctIndex) return Colors.greenAccent.withValues(alpha: 0.18);
    if (vm.sel == idx && !vm.correct) return Colors.redAccent.withValues(alpha: 0.18);
    return const Color(0xFF171717);
  }

  Color get _border {
    if (vm.sel == null) return Colors.white.withValues(alpha: 0.05);
    if (idx == vm.q!.correctIndex) return Colors.greenAccent.withValues(alpha: 0.60);
    if (vm.sel == idx && !vm.correct) return Colors.redAccent.withValues(alpha: 0.55);
    return Colors.white.withValues(alpha: 0.05);
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = vm.sel != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 170),
        scale: vm.sel == idx ? 0.985 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: disabled ? null : () => vm.submit(idx),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        String.fromCharCode(0x41 + idx),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.35,
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
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
              strokeWidth: 3.5,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'جارٍ تجهيز الأسئلة...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'لحظات ونبدأ الجولة',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
