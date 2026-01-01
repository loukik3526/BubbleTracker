import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/habit_provider.dart';
import 'screens/splash_screen.dart';

import 'utils/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager.instance.init();
  AudioManager.instance.playMusic();
  runApp(const FloatApp());
}

class FloatApp extends StatelessWidget {
  const FloatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: MaterialApp(
        title: 'Float',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF050511),
          primaryColor: const Color(0xFF6366F1),
          // Apply white color to default text theme
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.white, 
              displayColor: Colors.white,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
            primary: const Color(0xFF6366F1),
            surface: const Color(0xFF050511),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

