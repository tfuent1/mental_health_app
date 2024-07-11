import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../models/journal_entry.dart';

class JournalEntryForm extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  JournalEntryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                final entry = JournalEntry(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  date: DateTime.now(),
                );
                Provider.of<JournalProvider>(context, listen: false).addEntry(entry);
                _titleController.clear();
                _contentController.clear();
              }
            },
            child: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }
}
