import 'package:flutter/material.dart';
import '../models/duty.dart';

class DutyProvider with ChangeNotifier {
  final List<Duty> _duties = [];

  List<Duty> get duties => _duties;

  void addDuty(Duty duty) {
    _duties.add(duty);
    notifyListeners();
  }

  void toggleDutyCompletion(String id) {
    final dutyIndex = _duties.indexWhere((duty) => duty.id == id);
    if (dutyIndex != -1) {
      _duties[dutyIndex].isCompleted = !_duties[dutyIndex].isCompleted;
      notifyListeners();
    }
  }

  void removeDuty(String id) {
    _duties.removeWhere((duty) => duty.id == id);
    notifyListeners();
  }
}
