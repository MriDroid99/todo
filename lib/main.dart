import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen
import './screen/tab_screen.dart';
import './screen/add_task_screen.dart';

// Provider
import './provider/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Tasks(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/': (_) => TabScreen(),
          AddTaskScreen.routeName: (_) => AddTaskScreen(),
        },
      ),
    );
  }
}
