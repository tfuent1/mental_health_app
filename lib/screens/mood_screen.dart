import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../models/mood.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedMood;

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'emoji': 'images/terrific.png', 'name': 'Terrific'},
      {'emoji': 'images/good.png', 'name': 'Good'},
      {'emoji': 'images/meh.png', 'name': 'Meh'},
      {'emoji': 'images/bad.png', 'name': 'Bad'},
      {'emoji': 'images/terrible.png', 'name': 'Terrible'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: moods.map((mood) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['name'] as String?;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: _selectedMood == mood['name'] ? 75 : 65,
                    width: _selectedMood == mood['name'] ? 75 : 65,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedMood == mood['name'] ? Colors.blue : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(mood['emoji'] as String),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedMood != null && _descriptionController.text.isNotEmpty) {
                  final mood = Mood(
                    id: DateTime.now().toString(),
                    uid: '',
                    name: _selectedMood!,
                    date: DateTime.now(),
                    description: _descriptionController.text,
                  );
                  Provider.of<MoodProvider>(context, listen: false).addMood(mood);
                  setState(() {
                    _selectedMood = null;
                    _descriptionController.clear();
                  });
                }
              },
              child: const Text('Log Mood'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<MoodProvider>(
                builder: (context, moodProvider, child) {
                  return ListView.builder(
                    itemCount: moodProvider.moods.length,
                    itemBuilder: (context, index) {
                      final mood = moodProvider.moods[index];
                      return ListTile(
                        title: Text(mood.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${mood.description}'),
                            Text('Date: ${mood.date}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            Provider.of<MoodProvider>(context, listen: false).removeMood(mood.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
