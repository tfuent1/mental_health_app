import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/duty.dart';
import '../providers/duty_provider.dart';
import '../widgets/duty_list.dart';

class DutiesScreen extends StatelessWidget {
  final TextEditingController _dutyController = TextEditingController();

  DutiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duties'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _dutyController,
                    decoration: const InputDecoration(labelText: 'New Duty'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_dutyController.text.isNotEmpty) {
                      final duty = Duty(
                        id: DateTime.now().toString(),
                        title: _dutyController.text,
                      );
                      Provider.of<DutyProvider>(context, listen: false).addDuty(duty);
                      _dutyController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DutyProvider>(
              builder: (context, dutyProvider, child) {
                return DutyList(duties: dutyProvider.duties);
              },
            ),
          ),
        ],
      ),
    );
  }
}
