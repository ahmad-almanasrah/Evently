class UserModel {
  final String id;
  final String email;
  final String token;

  UserModel({required this.id, required this.email, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        token: json['token'],
      );
}
