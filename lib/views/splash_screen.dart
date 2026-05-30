import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;

  const SplashScreen({required this.onDone, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Image.asset(
          'assets/icons/app_icon.png',  // 👈 نفس الأيقونة
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}