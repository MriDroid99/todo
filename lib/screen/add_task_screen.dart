import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Provider
import '../provider/task.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = 'add_task_screen';
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var _titleController = TextEditingController();
  var _timeController = TextEditingController();
  var _dateController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _showTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) => setState(() {
        _selectedTime = value ?? TimeOfDay.now();
        _timeController.text =
            value?.format(context) ?? TimeOfDay.now().format(context);
      }),
    );
  }

  void _showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 7),
      ),
    ).then(
      (value) => setState(
        () => _dateController.text = DateFormat.yMMMd().format(
          value ?? DateTime.now(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: _showTime,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.schedule_sharp),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _showDate,
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Provider.of<Tasks>(context, listen: false).addTask(
                      _titleController.text,
                      _selectedTime!,
                      DateFormat().add_yMMMd().parse(_dateController.text));
                  Navigator.pop(context);
                },
                child: Text('Add Task'))
          ],
        ),
      ),
    );
  }
}
