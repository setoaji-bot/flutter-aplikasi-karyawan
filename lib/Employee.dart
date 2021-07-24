class Employee {
  String id;
  String name;
  String email;    

  Employee({this.id, this.name, this.email});

  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}