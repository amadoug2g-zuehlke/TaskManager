class Task {
  Task({required this.name});

  final String name;
  final DateTime date = DateTime.now();
  final bool completed = false;

  String get taskName => name;

  bool get taskStatus => completed;
}
