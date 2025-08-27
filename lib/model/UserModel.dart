class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? avatarUrl;


  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.avatarUrl,

  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl, // ✅ Save it
    };
  }
}
