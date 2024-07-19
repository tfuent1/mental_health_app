import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/duty_provider.dart';
import '../models/duty.dart';
import '../screens/duties/edit_duty_screen.dart';

class DutyList extends StatelessWidget {
  final List<Duty> duties;

  const DutyList({Key? key, required this.duties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Rendering DutyList with ${duties.length} duties");

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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDutyScreen(duty: duty),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Provider.of<DutyProvider>(context, listen: false).removeDuty(duty.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
