import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_model.dart';

class ChatModel {
  String id;
  List<String> uid;
  List<dynamic> listMess;

  ChatModel({
    required this.id,
    required this.uid,
    required this.listMess,
  });

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return ChatModel(
        id: snapshot.id,
        uid: List<String>.from(data['uid']),
        listMess: List<dynamic>.from(data['listMess']));
  }

}