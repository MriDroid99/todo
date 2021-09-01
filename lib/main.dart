import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen
import './screen/tab_screen.dart';
import './screen/add_task_screen.dart';
import './screen/waiting_screen.dart';

// Provider
import './provider/task.dart';

// Util
import './util/database_ref.dart';

void main() async {
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
        home: FutureBuilder(
          future: openDb(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabScreen();
            }
            return WaitingScreen();
          },
        ),
        routes: {
          AddTaskScreen.routeName: (_) => AddTaskScreen(),
        },
      ),
    );
  }
}
