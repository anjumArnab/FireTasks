class Task {
  String? id;
  String title;
  String description;
  String timeAndDate;
  String priority;
  bool isChecked;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.timeAndDate,
    required this.priority,
    required this.isChecked,
  });

  Map<String, dynamic> toMap() {
  return {
    'id': id ?? '', // Store Firestore document ID directly
    'title': title,
    'description': description,
    'timeAndDate': timeAndDate,
    'priority': priority,
    'isChecked': isChecked ? 1 : 0,
  };
}

  // Convert a Map into a Task
  factory Task.fromMapObject(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      timeAndDate: map['timeAndDate'],
      priority: map['priority'],
      isChecked: map['isChecked'] == 1,
    );
  }
}