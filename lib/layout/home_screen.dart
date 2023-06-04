import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Firebase/message_repository.dart';
import 'package:demo/Firebase/user_repository.dart';
import 'package:demo/item/chat_user_card.dart';
import 'package:demo/layout/login.dart';
import 'package:demo/layout/profile_screen.dart';
import 'package:demo/item/user_card.dart';
import 'package:demo/model/chat_model.dart';
import 'package:demo/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage(this.title);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  List<UserModel> listUser = [];
  List<ChatModel> listChat = [];

  int _currentIndex = 0;
  Stream<QuerySnapshot> userStream =
  FirebaseFirestore.instance.collection('users').snapshots();
  Stream<QuerySnapshot> messageStream =
  FirebaseFirestore.instance.collection('messages').snapshots();

  void onClickEditProfile(BuildContext context){
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
          return EditProfileScreen();
        },
      )
    );
  }
  void onClickLogOut(BuildContext context){
    Navigator.pushReplacement(
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
          return LoginPage();
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var tabs = [
      StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          List<ChatModel> chatList = snapshot.data!.docs
              .map((doc) => ChatModel.fromSnapshot(doc))
              .where((chat) =>
              (chat.uid).contains(FirebaseAuth.instance.currentUser?.uid))
              .toList();
          return ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                ChatModel chatModel = chatList[index];
                return ChatUserCard(chatModel);
              }
              );
        },
      ),

      StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          List<UserModel> userList = snapshot.data!.docs
                .map((doc) => UserModel.fromSnapshot(doc))
                .where((user) => user.uid != FirebaseAuth.instance.currentUser?.uid)
                .toList();
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              UserModel user = userList[index];
              return UserCard(user);
            },
          );
        },
      ),
      Container(child: ProfileScreen()),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Edit Profile',
                child: Text('Edit Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'Log Out',
                child: Text('Log Out'),
              ),
            ],
            onSelected: (String value) {
              if (value == 'Edit Profile') {
                onClickEditProfile(context);
              }
              if(value == "Log Out"){
                onClickLogOut(context);
              }
              // Xử lý hành động khi người dùng chọn một mục trong menu
            },
          ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.blue,
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              backgroundColor: Colors.red,
              label: 'Users'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Colors.greenAccent,
              label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
