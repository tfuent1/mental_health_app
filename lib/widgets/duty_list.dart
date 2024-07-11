import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/duty_provider.dart';
import '../models/duty.dart';

class DutyList extends StatelessWidget {
  final List<Duty> duties;

  const DutyList({super.key, required this.duties});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: duties.length,
      itemBuilder: (context, index) {
        final duty = duties[index];
        return ListTile(
          title: Text(duty.title),
          leading: Checkbox(
            value: duty.isCompleted,
            onChanged: (bool? value) {
              Provider.of<DutyProvider>(context, listen: false).toggleDutyCompletion(duty.id);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<DutyProvider>(context, listen: false).removeDuty(duty.id);
            },
          ),
        );
      },
    );
  }
}
