class Profile {
  String? userId;
  String name;
  String? phone;
  String email;
  String? profileImagePath;
  String role;
  String? username;

  Profile({
    this.userId,
    required this.name,
    this.phone,
    required this.email,
    this.profileImagePath,
    required this.role,
    this.username,
  });

  // Adding an unnamed constructor
  Profile.unNamed({
    this.userId,
    required this.name,
    this.phone,
    required this.email,
    this.profileImagePath,
    required this.role,
    this.username,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'profileImagePath': profileImagePath,
        'role': role,
        'username': username,
      };

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        userId: json['userId'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        profileImagePath: json['profileImagePath'],
        role: json['role'],
        username: json['username'],
      );
}
