class Task {
  Task({required String name}) : _name = name;

  final String _name;
  final DateTime _date = DateTime.now();
  bool _completed = false;
  bool _isEditing = false;

  DateTime get taskCreationDate => _date;

  String get taskName => _name;

  bool get taskStatus => _completed;

  bool get taskEditingStatus => _isEditing;

  Task copyWith({String? name, bool? completed, bool? isEditing}) {
    return Task(
      name: name ?? _name,
    )
      .._completed = completed ?? _completed
      .._isEditing = isEditing ?? _isEditing;
  }
}
