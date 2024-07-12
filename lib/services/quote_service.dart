import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteService {
  Future<String> fetchDailyQuote() async {
    try {
      final response = await http.get(Uri.parse('https://api.quotable.io/random'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'];
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (error) {
      // Handle errors such as network issues
      throw Exception('Failed to load quote: $error');
    }
  }
}
