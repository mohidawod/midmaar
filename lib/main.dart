import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'repositories/questions_repository.dart';
import 'repositories/user_repository.dart';
import 'services/game_service.dart';
import 'services/timer_service.dart';
import 'services/anti_repetition_service.dart';
import 'services/sound_service.dart';
import 'viewmodels/main_viewmodel.dart';
import 'views/splash_screen.dart';
import 'views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sound = SoundService();
  await sound.preload();

  final userRepo = UserRepository();  // 👈 أضف هذا السطر
  final user = await userRepo.getUser();  // 👈 أضف هذا السطر
  sound.setMute(user.isMuted);  // 👈 أضف هذا السطر

  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => QuestionsRepository()),
      Provider(create: (_) => UserRepository()),
      Provider(create: (_) => GameService()),
      Provider(create: (_) => TimerService()),
      Provider(create: (_) => AntiRepetitionService()),
      Provider.value(value: sound),
      ChangeNotifierProvider(create: (ctx) => MainViewModel(
        ctx.read(),  // UserRepository
        ctx.read(),  // SoundService 👈 أضف هذا السطر
      )..init()),
    ],
    child: const MidmaarApp(),
  ));
}

class MidmaarApp extends StatelessWidget {
  const MidmaarApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midmaar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
      ),
      home: Builder(builder: (ctx) => SplashScreen(onDone: () => Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen())))),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      locale: const Locale('ar'),
    );
  }
}