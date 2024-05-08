import 'package:flutter/material.dart';
import 'package:test_exam/add_task_screen.dart';
import 'package:test_exam/database_helper.dart';
import 'package:test_exam/task_entity.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<TaskEntity> tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTaskList();
  }

  Future<void> _refreshTaskList() async {
    List<TaskEntity> fetchedTasks = await dbHelper.getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: IconButton(
                onPressed: () async {
                  await dbHelper.deleteTask(tasks[index].id);
                  setState(() {});
                  _refreshTaskList();
                },
                icon: const Icon(Icons.delete)),
            title: InkWell(
                onTap: () async =>
                    await _addUpdateTask(context, task: tasks[index]),
                child: Text(
                  tasks[index].name,
                )),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async =>
                  await _addUpdateTask(context, task: tasks[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _addUpdateTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addUpdateTask(BuildContext context, {TaskEntity? task}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(task: task)),
    );
    _refreshTaskList();
  }
}
