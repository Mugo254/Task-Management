import 'dart:convert';

import 'package:flutter/material.dart';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  int id;
  String title;
  String priority;
  bool completed;
  DateTime? dueDate;
  String? dueTime;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.completed,
    this.dueDate,
    this.dueTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        priority: json["priority"],
        completed: json["completed"],
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        dueTime: json["dueTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "priority": priority,
        "completed": completed,
        "dueDate": formatDueDate(dueDate),
        "dueTime": dueTime
      };

  formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return null;
    return "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";
  }
}
