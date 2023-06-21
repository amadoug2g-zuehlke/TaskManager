import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;
import 'package:task_manager/src/features/task_list/data/state/TaskCubit.dart';
import 'package:task_manager/src/features/task_list/domain/models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _addItem(BuildContext context) {
    context.read<TaskCubit>().addTask(Task(name: controller.text));
    Navigator.pop(context);
  }

  void _deleteItem(BuildContext context) {
    context.read<TaskCubit>().deleteTask(Task(name: controller.text));
  }

  void _createDialog(BuildContext context) {
    slideDialog.showSlideDialog(
      context: context,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              "New task",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ElevatedButton(
              onPressed: () {
                //_addItem(context);
                controller.text.isNotEmpty ? _addItem(context) : null;
              },
              child: const Text("Create"),
            ),
          )
        ],
      ),
    );
  }

  void _deleteDialog(BuildContext context) {
    final Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );
    final Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        _deleteItem(context);
        Navigator.pop(context);
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text("Delete task"),
      content: const Text(
        "Delete this item?",
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createDialog(context),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<TaskCubit, List<Task>>(
            builder: (context, taskList) {
              return ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final task = taskList[index];
                  return ListTile(
                    title: Text(task.taskName),
                    onLongPress: () => _deleteDialog(context),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
