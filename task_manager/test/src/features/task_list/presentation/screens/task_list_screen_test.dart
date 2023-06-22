import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/src/features/task_list/data/state/TaskCubit.dart';
import 'package:task_manager/src/features/task_list/domain/models/task_model.dart';

void main() {
  group('TaskListScreen', () {
    test(
      'addTask adds item to Cubit',
      () {
        final taskCubit = TaskCubit();
        final initialTaskList = TaskCubit().state;

        taskCubit.addTask(Task(name: "New task"));

        expect(taskCubit.state.length, initialTaskList.length + 1);
        expect(taskCubit.state.last.taskName, "New task");
      },
    );

    test(
      'deleteTask removes item from Cubit',
      () {
        final taskCubit = TaskCubit();
        final initialTaskList = TaskCubit().state;

        taskCubit.addTask(Task(name: "New task"));

        expect(taskCubit.state.length, initialTaskList.length + 1);
        expect(taskCubit.state.last.taskName, "New task");

        taskCubit.deleteTask("New task");

        expect(taskCubit.state.length, initialTaskList.length);
        expect(
          taskCubit.state.contains((element) => element.taskName == "New task"),
          false,
        );
      },
    );

    test('deleteTask removes item not in Cubit', () {
      final taskCubit = TaskCubit();
      final initialTaskList = TaskCubit().state;

      taskCubit.addTask(Task(name: "New task"));

      expect(taskCubit.state.length, initialTaskList.length + 1);
      expect(taskCubit.state.last.taskName, "New task");

      taskCubit.deleteTask("New task!");

      expect(taskCubit.state.length, initialTaskList.length + 1);
      expect(taskCubit.state.last.taskName, "New task");
      expect(
        taskCubit.state.contains((element) => element.taskName == "New task!"),
        false,
      );
    });

    test('deleteTask removes all items with similar names', () {
      final taskCubit = TaskCubit();
      final initialTaskList = TaskCubit().state;

      taskCubit
        ..addTask(Task(name: "New task 1"))
        ..addTask(Task(name: "New task 2"))
        ..addTask(Task(name: "New task 1"));

      expect(taskCubit.state.length, initialTaskList.length + 3);

      taskCubit.deleteTask("New task 1");

      expect(taskCubit.state.length, initialTaskList.length + 1);
      expect(
        taskCubit.state.contains((element) => element.taskName == "New task 1"),
        false,
      );
    });
  });
}
