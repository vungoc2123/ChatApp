import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Firebase/message_repository.dart';
import 'package:demo/item/message_card.dart';
import 'package:demo/model/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/message_model.dart';

class ChatScreen extends StatefulWidget {
  String id;
  String name;
  ChatScreen(this.id, this.name);
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  Stream<DocumentSnapshot> messageStream = Stream.empty();
  TextEditingController _txtContent = TextEditingController();
  List<MessageModel> listMessage = [];
  bool? checkMatch = null;
  Future<void> fetchCheck() async {
    try {
      bool check = await MessageRepository().checkMatch(widget.id) ;
      setState(() {
        checkMatch = check;
      });
    } catch (error) {
      print('Lỗi khi lấy dữ liệu người dùng5: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCheck();
    messageStream = FirebaseFirestore.instance.collection('messages').doc(widget.id).snapshots();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    fetchCheck();
  }

  @override
  Widget build(BuildContext context) {
    if(checkMatch == null){
      return Card();
    }
    return StreamBuilder<DocumentSnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          listMessage.clear();
          var data = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> listMess = data!['listMess'];
          for(dynamic mess in listMess){
            MessageModel content = MessageModel.fromSnapshot(mess);
            listMessage.add(content);
          }
          //listMessage.sort((a,b)=> b.time.compareTo(a.time));
          return Scaffold(
            appBar: AppBar(title: Text(widget.name)),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      //reverse: true,
                      itemCount: listMessage.length,
                      itemBuilder: (context, index) {
                        MessageModel message = listMessage[index];
                        return MessageCard(message);
                      }),
                ),
                checkMatch! ? _chatInput() : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Không thể nhắn tin",style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
          );
        },
      );
  }

  Widget _chatInput() {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding:  EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                        child: TextField(

                      controller: _txtContent,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Type something...',
                          hintStyle: TextStyle(color: Colors.teal),
                          border: InputBorder.none),
                    )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.teal,
                        ))
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                DateTime now = DateTime.now();
                MessageModel message = MessageModel(uid: FirebaseAuth.instance.currentUser!.uid, content: _txtContent.text, time: now.toString());
                MessageRepository().addMessage(message,widget.id);
                _txtContent.text ='';
              },
              minWidth: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.send,
                color: Colors.teal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
