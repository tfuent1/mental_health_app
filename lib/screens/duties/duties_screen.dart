import 'package:flutter/material.dart';
import 'package:mental_health_app/models/duty.dart';
import 'package:mental_health_app/providers/duty_provider.dart';
import 'package:mental_health_app/widgets/duty_list.dart';
import 'package:provider/provider.dart';

class DutiesScreen extends StatelessWidget {
  final TextEditingController _dutyController = TextEditingController();

  DutiesScreen({Key? key}) : super(key: key);

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
                        id: '', // Will be set by Firestore
                        uid: '', // Will be set by Firestore
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
