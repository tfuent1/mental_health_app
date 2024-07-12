import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/emotion_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/duty_provider.dart';
import 'screens/home_screen.dart';
import 'screens/emotions_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/duties_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => DutyProvider()),
      ],
      child: MaterialApp(
        title: 'Mental Health App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/emotions': (context) => const EmotionsScreen(),
          '/journal': (context) => const JournalScreen(),
          '/duties': (context) => DutiesScreen(),
        },
      ),
    );
  }
}
