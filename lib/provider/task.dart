import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Util
import '../util/database_ref.dart';

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
  List<Task> _tasks = [];

  List<Task> tasks({Status? status}) =>
      _tasks.where((element) => element.status == status).toList();

  Task findById(int id) => _tasks.firstWhere((element) => element.id == id);

  Future<void> getData() async {
    List<Map<String, dynamic>> data =
        await database_ref!.rawQuery('select * from tasks');
    _tasks.clear();
    data.forEach((element) {
      String time = element['time'].substring(10, 15);
      _tasks.add(
        Task(
          id: element['id'],
          title: element['title'],
          time: TimeOfDay(
            hour: int.parse(time.split(':')[0]),
            minute: int.parse(
              time.split(':')[1],
            ),
          ),
          date: DateTime.parse(element['date']),
          status: convertToStatus(element['status']),
        ),
      );
    });
  }

  Future<void> addTask(String title, TimeOfDay time, DateTime date) async {
    await database_ref!.transaction((txn) async {
      int id = await txn.rawInsert(
          'insert into tasks (title, time, date) values ("$title", "$time", "$date")');
      // _tasks.add(
      //   Task(
      //     id: id,
      //     title: title,
      //     time: time,
      //     date: date,
      //   ),
      // );
    });

    notifyListeners();
  }

  Future<void> changeStatus(int id, Status status) async {
    await database_ref!.rawUpdate(
        'UPDATE tasks SET status = "${convertFromStatus(status)}" WHERE id = $id');
    // _tasks.firstWhere((element) => element.id == id).status = status;
    notifyListeners();
  }

  Future<void> updateTask(
      int id, String title, TimeOfDay time, DateTime date) async {
    await database_ref!.rawUpdate(
      'UPDATE tasks SET title = "$title", time = "$time", date = "$date" WHERE id = $id',
    );
    notifyListeners();
  }

  Future<void> removeTask(int id) async {
    await database_ref!.rawDelete('DELETE FROM tasks WHERE id = $id');
    // _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

String convertFromStatus(Status status) {
  if (status == Status.Completed) {
    return 'Completed';
  }
  return 'In Progress';
}

Status? convertToStatus(String? status) {
  if (status == 'Completed') {
    return Status.Completed;
  } else if (status == 'In Progress') {
    return Status.InProgress;
  } else {
    return null;
  }
}

// TimeOfDay stringToTimeOfDay(String tod) {
//   final format = DateFormat.jm(); //"6:00 AM"
//   return TimeOfDay.fromDateTime(format.parse(tod));
// }
