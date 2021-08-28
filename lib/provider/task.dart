import 'package:flutter/material.dart';

enum Status { InProgress, Completed }

class Task with ChangeNotifier {
  int id;
  String title;
  DateTime date;
  TimeOfDay time;
  Status? status;

  Task({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    this.status,
  });
}

class Tasks with ChangeNotifier {
  List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Title1',
      time: TimeOfDay.now(),
      date: DateTime.now(),
    ),
    Task(
      id: 2,
      title: 'Title2',
      time: TimeOfDay.now(),
      date: DateTime.now(),
    ),
    Task(
      id: 3,
      title: 'Title3',
      time: TimeOfDay.now(),
      date: DateTime.now(),
    ),
  ];

  List<Task> tasks({Status? status}) =>
      _tasks.where((element) => element.status == status).toList();

  void addTask(String title, TimeOfDay time, DateTime date) {
    _tasks.add(
      Task(
        id: _tasks.length + 1,
        title: title,
        time: time,
        date: date,
      ),
    );

    notifyListeners();
  }

  void changeStatus(int id, Status status) {
    _tasks.firstWhere((element) => element.id == id).status = status;
    notifyListeners();
  }

  void updateTask(int id, String title, TimeOfDay time, DateTime date) {
    // TODO - Write yout Code
  }

  void removeTask(int id) {
    _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
