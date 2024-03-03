import 'dart:ffi';

class Todo {
  int? id;
  bool completed;
  String content;
  int groupId;
  String? description;

  Todo(
      {this.id,
      this.completed = false,
      this.content = '',
      this.groupId = 0,
      this.description});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'completed': completed ? 1 : 0,
      'content': content,
      'groupId': groupId,
      'description': description
    };
  }

  static Todo fromMap(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as int,
      completed: (map['completed'] as int) == 1,
      content: map['content'] as String,
      groupId: map['groupId'] as int,
      description: map['description'] as String?,
    );
  }
}
