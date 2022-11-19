class User {
  late final String firstName;
  late final String lastName;
  late final String  email;
  late final String  password;

  User({ required this.firstName, required this.lastName,
    required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }
}
