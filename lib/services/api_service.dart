import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_synced/models/task.dart';

class ApiService {
  Future<String> _getFilePath() async {
    final directory = await getTemporaryDirectory();
    // print("Directory, $directory");
    return '${directory.path}/task.json';
  }

  /// fetch all available tasks.
  ///
  /// Since files in assets folder cannot be written on during runtime, Copy the assests mock json file to a temporary directory on phone and before fetching.
  ///
  /// check first if it exists on specified phone directory and use the directory file for the GET request else use the assets folder/mock/task.json.
  ///
  /// When using the assets folder/mock/task.json lastly is to write the json file to the directory before you return the list of available tasks.
  ///
  /// return a list of available tasks.
  ///
  Future<List<Task>> getTasks() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      String response = await file.readAsString();
      List<dynamic> results = json.decode(response);
      return results.map((result) => Task.fromJson(result)).toList();
    } else {
      debugPrint("Local file not found, loading from assets...");
      final response = await rootBundle.loadString('assets/mock/task.json');

      List<dynamic> results = json.decode(response);

      await file.writeAsString(json.encode(results));

      return results.map((result) => Task.fromJson(result)).toList();
    }
  }

  /// GET task by providing a taskId.
  ///
  /// [taskId] is the argument to provide.
  ///
  /// returns Task that matches the taskId provided.
  ///
  Future<Task?> getTaskById(String taskId) async {
    List<Task> tasks = await getTasks();
    return tasks.firstWhere((task) => task.id == int.parse(taskId));
  }

  /// PATCH a select [taskId] object.
  ///
  /// [taskId] and [updatedTask] are the arguments to provide.
  ///
  /// return an updated Task object that matches the taskId provided.
  ///
  Future<void> updateTaskById(String taskId, Task updatedTask) async {
    List<Task> tasks = await getTasks();

    int index = tasks.indexWhere((task) => task.id == int.parse(taskId));
    if (index == -1) {
      debugPrint("Task with ID $taskId not found.");
      return;
    }

    tasks[index] = updatedTask;

    await updateTasks(tasks);
    debugPrint("Task with ID $taskId updated successfully.");
  }

  Future<void> updateTasks(List<Task> newTasks) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      String updatedJson =
          json.encode(newTasks.map((task) => task.toJson()).toList());
      await file.writeAsString(updatedJson);

      debugPrint("Task file updated successfully!");
    } catch (e) {
      debugPrint("Error updating tasks: $e");
    }
  }

  /// POST a created task.
  ///
  /// [newTask] is the argument to provide.
  ///
  Future<void> addTask(Task newTask) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      List<Task> tasks = [];

      if (await file.exists()) {
        String content = await file.readAsString();
        if (content.isNotEmpty) {
          List<dynamic> jsonData = json.decode(content);
          tasks = jsonData.map((taskJson) => Task.fromJson(taskJson)).toList();
        }
      }

      tasks.add(newTask);

      String updatedJson =
          json.encode(tasks.map((task) => task.toJson()).toList());

      await file.writeAsString(updatedJson);

      debugPrint("Task added successfully!");
    } catch (e) {
      debugPrint("Error adding task: $e");
    }
  }

  /// DELETE a specified task using the [taskId].
  ///
  /// [taskId] is the argument to provide.
  ///
  Future<void> deleteTask(String taskId) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        String response = await file.readAsString();
        List<dynamic> results = json.decode(response);
        List<Task> tasks =
            results.map((result) => Task.fromJson(result)).toList();

        tasks.removeWhere((task) => task.id == int.parse(taskId));

        await file.writeAsString(
            json.encode(tasks.map((task) => task.toJson()).toList()));
      } else {
        debugPrint("Task file does not exist.");
      }
    } catch (e) {
      debugPrint("Error deleting task: $e");
    }
  }
}
