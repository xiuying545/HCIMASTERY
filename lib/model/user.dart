class Profile {
  String? userId;
  String name;
  String? phone;
  String email;
  String? profileImage;
  String role;
  String? username;

  Profile({
    this.userId,
    required this.name,
    this.phone,
    required this.email,
    this.profileImage,
    required this.role,
    this.username,
  });

  // Adding an unnamed constructor
  Profile.unNamed({
    this.userId,
    required this.name,
    this.phone,
    required this.email,
    this.profileImage,
    required this.role,
    this.username,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'profileImage': profileImage,
        'role': role,
        'username': username,
      };

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        userId: json['userId'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        profileImage: json['profileImage'],
        role: json['role'],
        username: json['username'],
      );
}
