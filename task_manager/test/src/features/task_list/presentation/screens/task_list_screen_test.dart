import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slide_popup_dialog_null_safety/slide_dialog.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/src/features/task_list/data/state/TaskCubit.dart';
import 'package:task_manager/src/features/task_list/domain/models/task_model.dart';
import 'package:task_manager/src/features/task_list/presentation/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen', () {
    group('Action lists', () {
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
            taskCubit.state
                .contains((element) => element.taskName == "New task"),
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
          taskCubit.state
              .contains((element) => element.taskName == "New task!"),
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
          taskCubit.state
              .contains((element) => element.taskName == "New task 1"),
          false,
        );
      });
    });
    group('Action Dialogs', () {
      testWidgets('list be should empty on start', (tester) async {
        await tester.pumpWidget(const MyApp());

        final listViewFinder = find.byType(ListView);

        expect(listViewFinder, findsOneWidget);

        final childWidgets = tester.widgetList(
          find.descendant(
            of: listViewFinder,
            matching: find.byType(
              Widget,
            ),
          ),
        );

        expect(childWidgets.length, 0);
      });
      testWidgets('createDialog should show proper dialog', (tester) async {
        await tester.pumpWidget(const MyApp());

        expect(find.byType(FloatingActionButton), findsOneWidget);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        expect(find.byType(SlideDialog), findsOneWidget);
      });
      testWidgets('createDialog should populate listview', (tester) async {
        await tester.pumpWidget(const MyApp());

        expect(find.byType(FloatingActionButton), findsOneWidget);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        final textFieldFinder = find.byType(TextField);
        await tester.enterText(textFieldFinder, 'New task!');
        await tester.pump();

        await tester.ensureVisible(find.byType(ElevatedButton));

        expect(find.byType(SlideDialog), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));

        final listViewFinder = find.byType(ListView);

        await tester.pumpAndSettle();

        expect(find.byType(SlideDialog), findsNothing);
        expect(listViewFinder, findsOneWidget);
        expect(find.text('New task!'), findsOneWidget);
      });
      testWidgets('deleteItem should remove listview item', (tester) async {
        await tester.pumpWidget(const MyApp());

        expect(find.byType(FloatingActionButton), findsOneWidget);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        final textFieldFinder = find.byType(TextField);
        await tester.enterText(textFieldFinder, 'New task!');
        await tester.pump();

        await tester.ensureVisible(find.byType(ElevatedButton));

        expect(find.byType(SlideDialog), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));

        final listViewFinder = find.byType(ListView);

        await tester.pumpAndSettle();

        expect(find.byType(SlideDialog), findsNothing);
        expect(listViewFinder, findsOneWidget);
        expect(find.text('New task!'), findsOneWidget);

        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(listViewFinder, findsOneWidget);

        final childWidgets = tester.widgetList(
          find.descendant(
            of: listViewFinder,
            matching: find.byType(
              Widget,
            ),
          ),
        );

        expect(childWidgets.length, 0);
      });
    });
  });
}
//testWidgets('deleteDialog should show proper dialog', () async {});
