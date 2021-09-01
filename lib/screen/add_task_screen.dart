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
  bool _isFirst = true;
  var arg;
  Task? task;
  var _titleController = TextEditingController();
  var _timeController = TextEditingController();
  var _dateController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

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

  // @override
  // void initState() {
  //   var arg = ModalRoute.of(context)!.settings.arguments;
  //   print(arg);
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (_isFirst) {
      arg = ModalRoute.of(context)!.settings.arguments;
      print(arg);
      if (arg != null) {
        task = Provider.of<Tasks>(context, listen: false).findById(arg['id']);
        _titleController.text = task!.title;
        _timeController.text = task!.time.format(context);
        _dateController.text = DateFormat.yMMMd().format(task!.date);
      }
      _isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
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
                  task == null
                      ? Provider.of<Tasks>(context, listen: false).addTask(
                          _titleController.text,
                          _selectedTime,
                          DateFormat().add_yMMMd().parse(_dateController.text))
                      : Provider.of<Tasks>(context, listen: false).updateTask(
                          arg['id'],
                          _titleController.text,
                          _selectedTime,
                          DateFormat().add_yMMMd().parse(_dateController.text),
                        );
                  Navigator.pop(context);
                },
                child: Text(task == null ? 'Add Task' : 'Edit Task'))
          ],
        ),
      ),
    );
  }
}
