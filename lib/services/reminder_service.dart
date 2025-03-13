import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReminderService {
  static const platform = MethodChannel('task_reminder_channel');

  Future<void> setReminder(
      int taskId, String title, String description, DateTime dueDate) async {
    try {
      await platform.invokeMethod('setReminder', {
        "taskId": taskId,
        "title": title,
        "description": description,
        "dueDate": dueDate.millisecondsSinceEpoch,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to set reminder: '${e.message}'.");
    }
  }

  Future<void> cancelReminder(int taskId) async {
    try {
      await platform.invokeMethod('cancelReminder', {
        "taskId": taskId,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to cancel reminder: '${e.message}'.");
    }
  }
}
