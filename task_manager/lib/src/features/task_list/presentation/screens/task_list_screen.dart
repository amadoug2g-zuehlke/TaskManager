import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/features/task_list/data/state/TaskCubit.dart';
import 'package:task_manager/src/features/task_list/domain/models/task_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  void addItem(BuildContext context) {
    context.read<TaskCubit>().addTask(Task(name: "New")); // New
    //BlocProvider.of<TaskCubit>(context).addTask(Task(name: "New")); // Former
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addItem(context),
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
