import 'package:flutter/material.dart';
import 'package:task_manager/src/features/task_list/presentation/screens/task_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(),
    );
  }
}
