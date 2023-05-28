// ignore_for_file: file_names

class ProfileModel {
  String? uid;
  String? email;
  String? username;

  String? profileImageUrl;
  List<String>? questions;
  List<String>? posts;

  ProfileModel(
      {this.uid,
      this.email,
      this.username,
      this.profileImageUrl,
      this.questions,
      this.posts});

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      profileImageUrl: map['profileImageUrl'],
      questions: List<String>.from(map['questions'] ?? []),
      posts: List<String>.from(map['posts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'questions': questions,
      'posts': posts,
    };
  }
}
