import 'dart:developer';

class User {
  String? id;
  String? name;
  String? email;
  String? token;
  String? phone;
  String? avatar;
  String? shortBio;
  bool? isDeleted;
  String? createdAt;
  int? postCount;

  User({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.token,
    this.phone,
    this.avatar,
    this.shortBio,
    this.isDeleted,
    this.postCount,
  });

  User.fromJson(Map<String, dynamic> json) {
    var user = json['user'];

    id = user['_id'];
    name = user['name'];
    email = user['email'] ?? "";
    phone = user['phone'] ?? "";
    avatar = user['avatar'] ?? "";
    shortBio = user['shortBio'] ?? "";
    isDeleted = user['isDeleted'] ?? false;
    createdAt = user['createdAt'] ?? "";
    postCount = user['posts'] != null ? user['posts'].length : 0;

    token = json['token'] ?? "";
  }
}
//phone avatar shortBio isDeleted