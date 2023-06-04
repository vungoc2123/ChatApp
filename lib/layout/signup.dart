import 'package:demo/Firebase/user_repository.dart';
import 'package:demo/layout/login.dart';
import 'package:demo/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController _textName = TextEditingController();
  TextEditingController _textEmail = TextEditingController();
  TextEditingController _textPass = TextEditingController();
  TextEditingController _textConfirmPass = TextEditingController();


  Future<void> createUserWithEmailAndPassword() async{
    try{
      // await Auth().createUserWithEmailAndPassword(
      //     email: _textEmail.text,
      //     password: _textPass.text
      // );
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _textEmail.text,
          password:  _textPass.text
      );
      List<String> empty =[];
      UserModel userModel = UserModel(uid: '', name: _textName.text, email: _textEmail.text,date: '', avatar :'',match: empty, wait: empty, request: empty);
      UserRepository().addUser(userModel,userCredential.user!.uid);
    }on FirebaseAuthException catch (e){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Đăng ký thất bại!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void onClickSignUp(BuildContext context) {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
    createUserWithEmailAndPassword();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Đăng ký thành công!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  void onClickLogin(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset('assets/logoApp.png'),
            const Text(
              'Đăng ký',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("create account"),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _textName,
                decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                style: const TextStyle(
                  fontSize: 18, // Đặt kích thước font chữ cho text
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _textEmail,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                style: const TextStyle(
                  fontSize: 18, // Đặt kích thước font chữ cho text
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _textPass,
                decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                obscureText: true,
                style: const TextStyle(
                  fontSize: 18, // Đặt kích thước font chữ cho text
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _textConfirmPass,
                decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                obscureText: true,
                style: const TextStyle(
                  fontSize: 18, // Đặt kích thước font chữ cho text
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  onClickSignUp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                    fixedSize: const Size(200, 30)
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            RichText(text: TextSpan(
              style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Bạn đã có tài khoản? '),
                  TextSpan(text: 'Đăng nhập',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap = () {
                       onClickLogin(context);
                      },
                  ),
                ]
            ))
          ],
        ),
      ),
    );
  }
}

