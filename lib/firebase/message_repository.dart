
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class MessageRepository{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createChat(ChatModel chat) async {
    CollectionReference message = await firestore.collection('messages');
    Map<String, Object> data = HashMap();
    data['id'] = '';
    data['uid'] = chat.uid;
    data['listMess'] = chat.listMess;
    return message.add(data).then((DocumentReference docRef) {
      docRef.update({'id': docRef.id});
    }).catchError(
      (error) => print('Lỗi khi thêm người dùng vào Firestore: $error'));
  }

  Future<List<ChatModel>> getChats() async {
    List<ChatModel> list =[];
    FirebaseFirestore.instance
        .collection('messages')
        .where('uid', arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        ChatModel chatModel = ChatModel.fromSnapshot(doc);
        list.add(chatModel);
      });
    });
    return list;
  }
  Future<List<dynamic>> getInfoChat(String id) async {
    List<dynamic> listDyanmic =[];
    MessageModel  messageModel = MessageModel(uid: '', content: '', time: '') ;
    String uid ='';
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(id)
        .get()
        .then((DocumentSnapshot snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<MessageModel> list = [];
        List<dynamic> listMess = data['listMess'];
        List<dynamic> listUid = data['uid'];
        if(listMess.isNotEmpty){
          for(dynamic mess in listMess){
            MessageModel content = MessageModel.fromSnapshot(mess);
            list.add(content);
          }
          list.sort((a,b)=> a.time.compareTo(b.time));
          messageModel = list[list.length-1];
        }
        for(dynamic uid2 in listUid){
          if(uid2 != FirebaseAuth.instance.currentUser!.uid){
            uid = uid2;
          }
        }
    });
    listDyanmic.add(messageModel);
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (snapshot.exists) {
      // Lấy dữ liệu từ snapshot và tạo đối tượng User
      UserModel user = UserModel.fromSnapshot(snapshot);
       listDyanmic.add(user);
    }
    return listDyanmic;
  }

  Future<void> addMessage(MessageModel message, String id) async {
    DocumentReference docRef = await firestore.collection('messages').doc(id);
    Map<String, Object> data = HashMap();
    data['uid'] = message.uid;
    data['time'] = message.time;
    data['content'] = message.content;
    docRef.update({'listMess': FieldValue.arrayUnion([data])});
  }

  Future<bool> checkMatch(String id) async {
    DocumentSnapshot snapshot = await firestore.collection('messages').doc(id).get();
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
    if (snapshot.exists) {
      // Lấy dữ liệu từ snapshot và tạo đối tượng
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> listUid = data['uid'];
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> listUser = userData["matchs"];

      for(dynamic uidChat in listUid){
        for(dynamic match in listUser){
            if(uidChat == match){
              return true;
            }
        }
      }
    } else {
      throw Exception('Không tìm thấy dữ liệu');
    }
    return false;
  }

  Future<List<MessageModel>> getMessages(String id) async {
    DocumentSnapshot snapshot = await firestore.collection('messages').doc(id).get();
    if (snapshot.exists) {
      // Lấy dữ liệu từ snapshot và tạo đối tượng
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<MessageModel> list = [];
      List<dynamic> listMess = data['listMess'];
      for(dynamic mess in listMess){
        MessageModel content = MessageModel.fromSnapshot(mess);
        list.add(content);
      }
      return list ?? [];
    } else {
      throw Exception('Không tìm thấy dữ liệu');
    }
  }

}