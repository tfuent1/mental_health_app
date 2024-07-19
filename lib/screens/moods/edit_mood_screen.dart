import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mood.dart';
import '../../providers/mood_provider.dart';

class EditMoodScreen extends StatefulWidget {
  final Mood mood;

  const EditMoodScreen({Key? key, required this.mood}) : super(key: key);

  @override
  _EditMoodScreenState createState() => _EditMoodScreenState();
}

class _EditMoodScreenState extends State<EditMoodScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late String _selectedMood;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.mood.description);
    _selectedMood = widget.mood.name;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
        title: const Text('Edit Mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: moods.map((mood) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = mood['name'] as String;
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Provider.of<MoodProvider>(context, listen: false).updateMood(
                      widget.mood.id,
                      _selectedMood,
                      _descriptionController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
