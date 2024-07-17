import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/quote_service.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key); // Remove 'const' here

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _dailyQuote,
                style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/moods');
              },
              child: const Text('Mood'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/journal');
              },
              child: const Text('Journal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/duties');
              },
              child: const Text('Duties'),
            ),
          ],
        ),
      ),
    );
  }
}
