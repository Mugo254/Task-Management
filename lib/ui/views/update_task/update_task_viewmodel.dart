import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:task_synced/app/app.locator.dart';
import 'package:task_synced/app/app.router.dart';
import 'package:task_synced/models/task.dart';
import 'package:task_synced/services/api_service.dart';
import 'package:task_synced/services/reminder_service.dart';

class UpdateTaskViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _reminderService = locator<ReminderService>();

  final formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  String? selectedPriority;
  DateTime? dueDate;
  bool isCompleted = false;
  Task? task;
  TimeOfDay? dueTime;

  List<String> priorities = ["Low", "Medium", "High"];

  void setPriority(String? priority) {
    selectedPriority = priority;
    notifyListeners();
  }

  void setCompletedStatus(bool completed) {
    isCompleted = completed;
    notifyListeners();
  }

  void setDueDate(DateTime? date) {
    dueDate = date;
    notifyListeners();
  }

  void setTimeDue(TimeOfDay? time) {
    dueTime = time;
    notifyListeners();
  }

  String timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void submitForm(String taskId) {
    if (formKey.currentState!.validate()) {
      String time = timeOfDayToString(dueTime!);
      // create a task object
      Task task = Task(
        id: int.parse(taskId),
        completed: isCompleted,
        priority: selectedPriority!,
        title: titleController.text.trim(),
        dueDate: formattedDueDate(dueDate),
        dueTime: time,
      );

      //submit that task object to the addtask function which will inturn send it to the add Task api service
      updateTask(taskId, task);
    }
  }

  Future<void> updateTask(String taskId, Task newTasks) async {
    TimeOfDay time = stringToTimeOfDay(newTasks.dueTime!);
    setBusy(true);
    await _apiService.updateTaskById(taskId, newTasks);
    _navigationService.replaceWithHomeView();

    DateTime combinedDateTime = DateTime(
      newTasks.dueDate!.year,
      newTasks.dueDate!.month,
      newTasks.dueDate!.day,
      time.hour,
      time.minute,
    );

    //once you edit a task then set a scheduled reminder for the due date
    if (newTasks.dueDate != null) {
      await _reminderService.setReminder(newTasks.id.hashCode, newTasks.title,
          "Task is due!", combinedDateTime);
    }

    setBusy(false);
    notifyListeners();
  }

  DateTime? formattedDueDate(DateTime? dueDate) {
    if (dueDate == null) return null;

    String formattedDate = DateFormat("yyyy-MM-dd").format(dueDate);
    return DateTime.parse(formattedDate);
  }

  int getRandomNumber() {
    Random random = Random();
    return random.nextInt(94) + 7;
  }

  void runstartUpLogic(int taskId) async {
    task = await _apiService.getTaskById(taskId.toString());

    titleController.text = task!.title;
    selectedPriority = task!.priority;
    isCompleted = task!.completed;
    dueDate = task!.dueDate;

    if (task!.dueTime != null) {
      dueTime = stringToTimeOfDay(task!.dueTime!);
    }

    notifyListeners();
  }
}
