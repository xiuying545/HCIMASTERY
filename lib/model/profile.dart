// user_model.dart
class UserModel {
  String name;
  String phone;
  String email;
  String? profileImagePath;  // Nullable to handle cases with no image

  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    this.profileImagePath,
  });

  // You can also add a method to convert this model to/from JSON if needed
  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'profileImagePath': profileImagePath,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        profileImagePath: json['profileImagePath'],
      );
}
