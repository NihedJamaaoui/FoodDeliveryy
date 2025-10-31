class User {
  int? id;
  String username;
  String email;
  String password;
  bool isAdmin;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username, // Update the field name
      'email': email, // Assuming email is used as a unique identifier
      'password': password,
      'isAdmin': isAdmin ? 1 : 0,
    };
  }
}
