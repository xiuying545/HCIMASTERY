// user_model.dart
class User {
  String? userId;
  String name;
  String phone;
  String email;
  String? profileImagePath; // Nullable to handle cases with no image

  User({
    this.userId,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'userId': userId,
        'phone': phone,
        'email': email,
        'profileImagePath': profileImagePath,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        profileImagePath: json['profileImagePath'],
      );
}
