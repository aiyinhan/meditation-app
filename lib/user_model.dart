class UserModel {
  final String name;
  final String email;
  final String age;
  final String bodyWeight;

  const UserModel({
    required this.name,
    required this.email,
    required this.age,
    required this.bodyWeight,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['Name'],
      email: json['Email'],
      age: json['Age'],
      bodyWeight: json['BodyWeight'],
    );
  }
}



