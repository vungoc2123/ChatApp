import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String avatar;
  String date;
  List<String> match;
  List<String> wait;
  List<String> request;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    required this.date,
    required this.match,
    required this.wait,
    required this.request,
  });


  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        avatar: data['avatar'],
        date: data['date'],
        match: List<String>.from(data['matchs']),
        wait: List<String>.from(data['waits']),
        request: List<String>.from(data['requests']));
  }
}
