import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import '../widgets/journal_entry_form.dart';
import 'journal_entry_detail_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<JournalProvider>(
              builder: (context, journalProvider, child) {
                return ListView.builder(
                  itemCount: journalProvider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = journalProvider.entries[index];
                    return ListTile(
                      title: Text(entry.title),
                      subtitle: Text(entry.date.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalEntryDetailScreen(entry: entry),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<JournalProvider>(context, listen: false).removeEntry(entry.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          JournalEntryForm(),
        ],
      ),
    );
  }
}
