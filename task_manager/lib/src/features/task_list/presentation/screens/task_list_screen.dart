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
  final createTaskController = TextEditingController();
  final editTaskController = TextEditingController();
  bool isEditing = false;

  @override
  void dispose() {
    createTaskController.dispose();
    editTaskController.dispose();
    super.dispose();
  }

  void _addItem(BuildContext context) {
    context.read<TaskCubit>().addTask(Task(name: createTaskController.text));
    createTaskController.clear();
    Navigator.pop(context);
  }

  void _deleteItem(BuildContext context, String name) {
    context.read<TaskCubit>().deleteTask(name);
  }

  void _updateStatusItem(BuildContext context, String name) {
    context.read<TaskCubit>().updateStatusTask(name);
  }

  void _updateEditingStatusItem(BuildContext context, String name) {
    context.read<TaskCubit>().updateEditingStatusTask(name);
  }

  void _updateTextItem(BuildContext context, String name, String newName) {
    _updateEditingStatusItem(context, name);
    context.read<TaskCubit>().updateTextTask(name, newName);
    editTaskController.clear();
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
              controller: createTaskController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ElevatedButton(
              onPressed: () {
                createTaskController.text.isNotEmpty ? _addItem(context) : null;
              },
              child: const Text("Create"),
            ),
          )
        ],
      ),
    );
  }

  void _deleteDialog(BuildContext context, String name) {
    final Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );
    final Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        _deleteItem(context, name);
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

  void _updateDialog(BuildContext context, int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () => _createDialog(context),
          child: const Icon(
            Icons.add,
          ),
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
                  return task.taskEditingStatus
                      ? ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: editTaskController
                                    ..text = task.taskName,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _updateTextItem(
                                    context,
                                    task.taskName,
                                    editTaskController.text,
                                  );
                                },
                                icon: const Icon(Icons.check),
                              ),
                              IconButton(
                                onPressed: () {
                                  _updateStatusItem(context, task.taskName);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        )
                      : ListTile(
                          leading: Checkbox(
                            value: task.taskStatus,
                            onChanged: (bool? value) {
                              _updateStatusItem(context, task.taskName);
                            },
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.taskName,
                                  style: task.taskStatus
                                      ? const TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        )
                                      : const TextStyle(
                                          color: Colors.black,
                                        ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _updateEditingStatusItem(
                                    context,
                                    task.taskName,
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteDialog(context, task.taskName);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
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
