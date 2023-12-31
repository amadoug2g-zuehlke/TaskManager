import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/features/task_list/domain/models/task_model.dart';

class TaskCubit extends Cubit<List<Task>> {
  TaskCubit() : super([]);

  void addTask(Task task) {
    final List<Task> newList = List.from(state);
    newList.add(task);
    emit(newList);
  }

  void deleteTask(String name) {
    final List<Task> newList = List.from(state);
    newList.removeWhere((item) => item.taskName == name);
    emit(newList);
  }

  void updateStatusTask(String name) {
    final List<Task> newList = state.map((task) {
      if (task.taskName == name) {
        return task.copyWith(completed: !task.taskStatus);
      }
      return task;
    }).toList();

    emit(newList);
  }

  void updateEditingStatusTask(String name) {
    final List<Task> newList = state.map((task) {
      if (task.taskName == name) {
        return task.copyWith(isEditing: !task.taskEditingStatus);
      }
      return task;
    }).toList();

    emit(newList);
  }

  void updateTextTask(String oldName, String newName) {
    final List<Task> newList = state.map((task) {
      if (task.taskName == oldName) {
        return task.copyWith(name: newName);
      }
      return task;
    }).toList();

    emit(newList);
  }
}
