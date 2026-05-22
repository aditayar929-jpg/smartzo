class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatar;
  final String? phone;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    this.phone,
    this.token,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar_url'],
      phone: json['billing']?['phone'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatar,
      'token': token,
    };
  }
}
