class Todo {
  final int? id;
  bool completed;
  String content;

  Todo({this.id, this.completed = false, this.content = ''});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'completed': completed ? 1 : 0,
      'content': content,
    };
  }

  static Todo fromMap(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as int,
      completed: (map['completed'] as int) == 1,
      content: map['content'] as String,
    );
  }
}
