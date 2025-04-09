class UserModel {
  final String email;
  final String password;
  final String? uid;  // Optional: if you plan to store user IDs
  final String? displayName; // Optional: if you plan to have a user name

  UserModel({
    required this.email,
    required this.password,
    this.uid,
    this.displayName,
  });

  // Optional: add toMap and fromMap methods if you plan to work with Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'uid': uid,
      'displayName': displayName,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      password: map['password'],
      uid: map['uid'],
      displayName: map['displayName'],
    );
  }
}
