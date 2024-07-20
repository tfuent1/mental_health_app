import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/quote_service.dart';
import '../widgets/navbar.dart';
import 'moods/mood_screen.dart';
import 'journals/journal_screen.dart';
import 'duties/duties_screen.dart';
import 'profile_screen.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _dailyQuote = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchDailyQuote();
  }

  void _fetchDailyQuote() async {
    final quoteService = QuoteService();
    final quote = await quoteService.fetchDailyQuote();
    setState(() {
      _dailyQuote = quote;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _dailyQuote,
            style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const MoodScreen(),
      const JournalScreen(),
      DutiesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
