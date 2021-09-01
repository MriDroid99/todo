import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Provider
import '../provider/task.dart';

// Screen
import '../screen/add_task_screen.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Task _task = Provider.of(context);
    return Slidable(
      closeOnScroll: true,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: FittedBox(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${_task.time.format(context)}'),
            )),
          ),
          title: Text('${_task.title}'),
          subtitle: Text('${DateFormat.yMMMd().format(_task.date)}'),
        ),
      ),
      actions: [
        IconSlideAction(
          caption: 'Edit',
          color: Colors.yellow,
          icon: Icons.edit,
          onTap: () => Navigator.pushNamed(context, AddTaskScreen.routeName,
              arguments: {'id': _task.id}),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () =>
              Provider.of<Tasks>(context, listen: false).removeTask(_task.id),
        ),
        if (_task.status != Status.InProgress)
          IconSlideAction(
            caption: 'In Progress',
            color: Colors.black45,
            icon: Icons.archive_outlined,
            onTap: () => Provider.of<Tasks>(context, listen: false)
                .changeStatus(_task.id, Status.InProgress),
          ),
        if (_task.status != Status.Completed)
          IconSlideAction(
            caption: 'Complete',
            color: Colors.blue,
            icon: Icons.done_all,
            onTap: () => Provider.of<Tasks>(context, listen: false)
                .changeStatus(_task.id, Status.Completed),
          ),
      ],
    );
  }
}
