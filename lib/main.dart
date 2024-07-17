import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/mood_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/duty_provider.dart';
import 'screens/home_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/duties_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodProvider()),
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
          '/moods': (context) => const MoodScreen(),
          '/journal': (context) => const JournalScreen(),
          '/duties': (context) => DutiesScreen(),
        },
      ),
    );
  }
}
