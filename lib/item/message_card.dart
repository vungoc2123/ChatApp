import 'package:demo/model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {

  MessageModel messageModel;
  MessageCard(this.messageModel);

  @override
  State<StatefulWidget> createState() {
    return MessageCardState();
  }
}

class MessageCardState extends State<MessageCard> {

  User? user = FirebaseAuth.instance.currentUser;
  bool checkUid = false;
  bool checkContent = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    if(user?.uid == widget.messageModel.uid){
      checkUid = true;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(user?.uid == widget.messageModel.uid){
      checkUid = true;
    }
    if(widget.messageModel.content.length > 30){
      checkContent = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    print(user!.uid);
    return  checkUid ? _greenMesssage() : _blueMesssage();
  }
  Widget _blueMesssage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: checkContent ? MediaQuery.of(context).size.width / 2 :null,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 127, 206, 239),
            border: Border.all(color: Colors.lightBlue),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Text(
            widget.messageModel.content,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            DateFormat('HH:mm a').format(DateTime.parse(widget.messageModel.time)),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _greenMesssage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            DateFormat('HH:mm a').format(DateTime.parse(widget.messageModel.time)),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
        Container(
          width: checkContent ? MediaQuery.of(context).size.width / 2 :null,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 120, 241, 175),
            border: Border.all(color: Colors.green),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          child: Text(
            widget.messageModel.content,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
