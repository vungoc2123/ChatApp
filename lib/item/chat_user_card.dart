import 'package:demo/layout/chat_screen.dart';
import 'package:demo/model/chat_model.dart';
import 'package:demo/model/message_model.dart';
import 'package:demo/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Firebase/message_repository.dart';

class ChatUserCard extends StatefulWidget {

  ChatModel chatModel;

  ChatUserCard(this.chatModel);

  @override
  State<StatefulWidget> createState() {
    return ChatUserCardState();
  }
}

class ChatUserCardState extends State<ChatUserCard> {
  // void onClickChatUser(BuildContext context){
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => ChatScreen()),
  //   );
  // }
  MessageModel? messageModel;
  UserModel? userModel;

  Future<void> fetchData() async {
    try {
      List<dynamic> listDynamic = await MessageRepository().getInfoChat(widget.chatModel.id) ;
      setState(() {
        messageModel = listDynamic[0];
        userModel = listDynamic[1];
      });
    } catch (error) {
      print('Lỗi khi lấy dữ liệu người dùng8: $error');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    fetchData();
  }
  void onClickChatUser(BuildContext context){
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 150), // Đặt thời gian chuyển đổi
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Điểm bắt đầu (từ phải qua trái)
              end: Offset.zero, // Điểm kết thúc (trái)
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          // Trang mới sau khi chuyển đổi
          return ChatScreen(widget.chatModel.id,userModel!.name);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(messageModel == null){
      return Card();
    }
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: InkWell(
            onTap: (){
              onClickChatUser(context);
            },
            child: ListTile(
              leading: userModel!.avatar != ""
                  ? CircleAvatar(
                backgroundImage: NetworkImage(userModel!.avatar?? ''),
                radius: 25,
              )
                  : const CircleAvatar(child: Icon(CupertinoIcons.person)),
              title: Text(userModel!.name?? ''),
              subtitle: Text(
                messageModel!.content,
                maxLines: 1,
              ),
              trailing: messageModel!.time != ''? Text(DateFormat('HH:mm a').format(DateTime.parse(messageModel!.time)), style: TextStyle(color: Colors.teal)): Text(''),
            )));
  }
}
