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
  double _intensity = 1;
  String? _selectedMood;

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'emoji': 'img1', 'name': 'Terrific '},
      {'emoji': 'img2', 'name': 'Good'},
      {'emoji': 'img3', 'name': 'Meh'},
      {'emoji': 'img4', 'name': 'Bad'},
      {'emoji': 'img5', 'name': 'Terrible'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 10.0,
              children: moods.map((mood) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedMood = mood['name'] as String?;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedMood == mood['name']
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: Text(mood['emoji']!),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Intensity: ${_intensity.round()}'),
            Slider(
              value: _intensity,
              min: 1,
              max: 10,
              divisions: 9,
              label: _intensity.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _intensity = value;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedMood != null) {
                  final mood = Mood(
                    id: DateTime.now().toString(),
                    name: _selectedMood!,
                    date: DateTime.now(),
                    description: _descriptionController.text,
                  );
                  Provider.of<MoodProvider>(context, listen: false).addMood(mood);
                  setState(() {
                    _selectedMood = null;
                    _intensity = 1;
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
