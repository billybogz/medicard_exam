class TaskEntity {
  int id;
  String name;
  bool completed;

  TaskEntity({required this.id, required this.name, required this.completed});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'completed': completed ? 1 : 0,
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'],
      name: map['name'],
      completed: map['completed'] == 1 ? true : false,
    );
  }

  TaskEntity copyWith({
    int? id,
    String? name,
    bool? completed,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      completed: completed ?? this.completed,
    );
  }
}
