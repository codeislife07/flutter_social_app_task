class UserModel {
  final String username;

  UserModel({required this.username});

  Map<String, dynamic> toMap() => {'username': username};

  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel(username: map['username']);
}
