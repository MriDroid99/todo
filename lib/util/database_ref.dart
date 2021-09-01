import 'package:sqflite/sqflite.dart';

Database? database_ref;

Future<void> openDb() async {
  database_ref = await openDatabase(
    'tasks.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'create table tasks (id integer primary key, title text, time text, date text, status text)');
      print('database Created');
    },
  );

  // await deleteDatabase('tasks.db');
}
