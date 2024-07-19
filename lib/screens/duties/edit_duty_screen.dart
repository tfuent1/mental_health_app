import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/duty.dart';
import '../providers/duty_provider.dart';

class EditDutyScreen extends StatefulWidget {
  final Duty duty;

  const EditDutyScreen({Key? key, required this.duty}) : super(key: key);

  @override
  _EditDutyScreenState createState() => _EditDutyScreenState();
}

class _EditDutyScreenState extends State<EditDutyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.duty.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Duty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Provider.of<DutyProvider>(context, listen: false).updateDuty(
                      widget.duty.id,
                      _titleController.text,
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
