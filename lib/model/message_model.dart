import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String uid;
  String content;
  String time;



  MessageModel({
    required this.uid,
    required this.content,
    required this.time,
  });

  factory MessageModel.fromSnapshot(Map<String, dynamic> data) {
    return MessageModel(
        uid: data['uid'],
        content: data['content'],
        time: data['time']
    );
  }
}