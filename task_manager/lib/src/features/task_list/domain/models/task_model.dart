class Task {
  Task({required String name}) : _name = name;

  String _name;
  final DateTime _date = DateTime.now();
  bool _completed = false;

  DateTime get taskCreationDate => _date;

  String get taskName => _name;

  bool get taskStatus => _completed;

  void updateStatus() => _completed = !_completed;

  Task copyWith({String? name, bool? completed}) {
    return Task(
      name: name ?? _name,
    ).._completed = completed ?? _completed;
  }
}
