class UserModel {
  String name;
  String motto;
  String email;
  int age;
  String dob;

  // Constructor
  UserModel({
    required this.name,
    required this.motto,
    required this.email,
    required this.age,
    required this.dob,
  });

  // Convert UserModel to a map (for Firebase or API calls)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'motto': motto,
      'email': email,
      'age': age,
      'dob': dob,
    };
  }

  // Convert a map to UserModel (for reading from Firebase or API calls)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      motto: map['motto'],
      email: map['email'],
      age: map['age'],
      dob: map['dob'],
    );
  }

  // Optional: Override toString for better debugging
  @override
  String toString() {
    return 'UserModel(name: $name, motto: $motto, email: $email, age: $age, dob: $dob)';
  }
}
