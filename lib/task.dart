class Task {
  final id;
  final String title;
   bool status;
  final String description;
 
  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
    
  });

  Map<String, dynamic> toJson() => {
  'id': id,
  'title': title,
  'description': description,
  'status': status,
};


  static Task fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
  status: json['status'] ?? false,
    description: json['description'], 
    
    );

}


