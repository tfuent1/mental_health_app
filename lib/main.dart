import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/emotion_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/duty_provider.dart';
import 'screens/home_screen.dart';
import 'screens/log_emotion_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/duties_screen.dart';
import 'screens/view_emotions_screen.dart';

void main() {
  runApp(MyApp());
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
          '/log-emotion': (context) => LogEmotionScreen(),
          '/view-emotions': (context) => ViewEmotionsScreen(),
          '/journal': (context) => JournalScreen(),
          '/duties': (context) => DutiesScreen(),
        },
      ),
    );
  }
}
