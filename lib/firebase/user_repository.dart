import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Firebase/message_repository.dart';
import 'package:demo/model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class UserRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user,String id) async {

    Map<String, Object> data = HashMap();
    data['uid'] = id;
    data['name'] = user.name;
    data['email'] = user.email;
    data['avatar'] = user.avatar;
    data['date'] = user.date;
    data['requests'] = user.request;
    data['waits'] = user.wait;
    data['matchs'] = user.match;
     await  FirebaseFirestore.instance.collection('users').doc(id).set(data)
         .catchError(
        (error) => print('Lỗi khi thêm người dùng vào Firestore: $error'));
  }

  Future<void> updateUser(String avatar,String name,String date) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    Map<String, Object> data = HashMap();
    data['avatar'] = avatar;
    data['name'] = name;
    data['date'] = date;
    docRef.update(data)
        .catchError(
            (error) => print('Lỗi khi cập nhật người dùng vào Firestore: $error'));
  }


  Future<UserModel?> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (snapshot.exists) {
      // Lấy dữ liệu từ snapshot và tạo đối tượng User
      UserModel user = UserModel.fromSnapshot(snapshot);
      return user;
    } else {
      // User không tồn tại trong Firestore
      return null;
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      QuerySnapshot querySnapshot = await users.get();
      List<UserModel> list = [];
      for (DocumentSnapshot snapshot in querySnapshot.docs) {
        if(snapshot.get("uid") != currentUserId){
          UserModel user = UserModel.fromSnapshot(snapshot);
          list.add(user);
        }
      }
      return list;
    } catch (error) {
      print('Lỗi khi lấy danh sách người dùng: $error');
      throw error;
    }
  }



  // filter
  Future<List<dynamic>> getListField(String field) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    print(userData);
    List<dynamic> list = userData[field] as List<dynamic>;
    return list ?? [];
  }

  Future<int> filter(String uid) async {
    List<dynamic> listRequest = await getListField('requests');
    for(String request in listRequest){
      if(uid == request){
        return 1;
      }
    }
    List<dynamic> listWait = await getListField('waits');
    for(String wait in listWait){
      if(uid == wait){
        return 2;
      }
    }
    List<dynamic> listMatch = await getListField('matchs');
    for(String match in listMatch){
      if(uid == match){
        return 3;
      }
    }
    return 4;
  }


  Future<void> match(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    //lấy data và sửa
    DocumentReference docRefA =
    await FirebaseFirestore.instance.collection('users').doc(user?.uid);
    DocumentReference docRefB =
    await FirebaseFirestore.instance.collection('users').doc(uid);

    docRefA.update({'requests': FieldValue.arrayUnion([uid])});
    //lấy data
    docRefB.update({'waits': FieldValue.arrayUnion([user?.uid])});
  }
  Future<void> unMatch(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    //lấy data và sửa
    DocumentReference docRefA = await FirebaseFirestore.instance.collection('users').doc(user?.uid);
    docRefA.update({
      'matchs': FieldValue.arrayRemove([uid]),
    });
    DocumentReference docRefB = await FirebaseFirestore.instance.collection('users').doc(uid);
    docRefB.update({
      'matchs': FieldValue.arrayRemove([user?.uid]),
    });
  }

  Future<void> confirmMatch(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    //lấy data và sửa
    DocumentReference docRefA = await FirebaseFirestore.instance.collection('users').doc(user?.uid);
    docRefA.update({
      'matchs': FieldValue.arrayUnion([uid]),
      'waits': FieldValue.arrayRemove([uid]),
    });
    DocumentReference docRefB = await FirebaseFirestore.instance.collection('users').doc(uid);
    docRefB.update({
      'matchs': FieldValue.arrayUnion([user?.uid]),
      'requests': FieldValue.arrayRemove([user?.uid]),
    });
    List<String> listUid = [uid,user!.uid];
    List<dynamic> listMess = [];
    Map<String, dynamic> data = HashMap();
    data['id'] = '';
    data['uid'] = listUid;
    data['listMess'] = listMess;
    ChatModel chatModel = ChatModel(id: '', uid: listUid, listMess: listMess);
    MessageRepository().createChat(chatModel);
  }

  Future<void> cancel(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    //lấy data và sửa
    DocumentReference docRefA = await FirebaseFirestore.instance.collection('users').doc(user?.uid);
    docRefA.update({
      'requests': FieldValue.arrayRemove([uid]),
      'waits': FieldValue.arrayRemove([uid]),
    });
    DocumentReference docRefB = await FirebaseFirestore.instance.collection('users').doc(uid);
    docRefB.update({
      'waits': FieldValue.arrayRemove([user?.uid]),
      'requests': FieldValue.arrayRemove([user?.uid]),
    });
  }

}
