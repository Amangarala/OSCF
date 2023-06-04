// ignore_for_file: file_names

class ProfileModel {
  String? uid;
  String? email;
  String? username;

  String? profileImageUrl;
  List<String>? questions;

  ProfileModel({
    this.uid,
    this.email,
    this.username,
    this.profileImageUrl,
    this.questions,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      profileImageUrl: map['profileImageUrl'],
      questions: List<String>.from(map['questions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'questions': questions,
    };
  }
}
