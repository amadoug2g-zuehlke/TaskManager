import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/src/features/task_list/domain/models/task_model.dart';

class TaskCubit extends Cubit<List<Task>> {
  TaskCubit() : super([]);

  void addTask(Task task) {
    final List<Task> newList = List.from(state);
    newList.add(task);
    emit(newList);
  }

  void deleteTask(Task task) {
    final List<Task> newList = List.from(state);
    newList.removeWhere((item) => item.name == task.taskName);
    emit(newList);
  }

  void updateTask(Task task) {
    List<Task> newList = List.from(state);
    // TODO: Update data
    emit(newList);
  }
}
