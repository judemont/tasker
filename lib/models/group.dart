class Group {
  final int? id;
  String name;

  Group({this.id,  this.name = ''});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Group fromMap(Map<String, Object?> map) {
    print("GROUP-MAP length :"+map.length.toString());
    return Group(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}