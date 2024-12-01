class Profile {
  String? userId;
  String name;
  String? phone;
  String email;
  String? profileImagePath;
  String role;

  Profile({
    this.userId,
    required this.name,
    this.phone,
    required this.email,
    this.profileImagePath,
    required this.role,
  });

  // Adding an unnamed constructor
  Profile.unNamed({
    this.userId,
    required this.name,
    this.phone,
    required this.email,
    this.profileImagePath,
     required this.role,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'userId': userId,
    'phone': phone,
    'email': email,
    'profileImagePath': profileImagePath,
    'role':role,
  };

  static Profile fromJson(Map<String, dynamic> json) => Profile(
    userId: json['userId'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    profileImagePath: json['profileImagePath'],
    role:json['role'],
  );
}
