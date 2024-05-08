import 'package:flutter/material.dart';
import 'package:test_exam/database_helper.dart';
import 'package:test_exam/task_entity.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, this.task});

  final TaskEntity? task;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  late TextEditingController _taskController;

  @override
  void initState() {
    _taskController = TextEditingController(
        text: widget.task != null ? widget.task!.name : '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Task',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (widget.task == null) {
                  int epoch = DateTime.now().millisecondsSinceEpoch;
                  TaskEntity newTask = TaskEntity(
                    name: _taskController.text,
                    completed: false,
                    id: epoch,
                  );
                  await dbHelper.insertTask(newTask);
                } else {
                  TaskEntity newTask =
                      widget.task!.copyWith(name: _taskController.value.text);
                  await dbHelper.updateTask(newTask);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              child: Text(
                widget.task == null ? 'Add Task' : 'Update name task',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
