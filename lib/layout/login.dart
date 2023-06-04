import 'package:demo/Firebase/auth.dart';
import 'package:demo/layout/home_screen.dart';
import 'package:demo/layout/signup.dart';
import 'package:demo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}
class LoginPageState extends State<LoginPage>{

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPass = TextEditingController();
  bool _isRemember = false;
  SharedPreferences? prefs ;

  Future<void> _loadSavedData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRemember = prefs!.getBool('remember') ?? false;
      if (_isRemember) {
        _controllerEmail.text = prefs!.getString('email') ?? '';
        _controllerPass.text = prefs!.getString('password') ?? '';
      }
    });
  }
  void remember(){
    if(_isRemember){
      prefs!.setString('email', _controllerEmail.text);
      prefs!.setString('password', _controllerPass.text);
      prefs!.setBool("remember", _isRemember);
    }else{
      prefs!.remove("remember");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void onClickLogin(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage("ChatApp")));
  }
  void onClickSignUp(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  Future<void> signInWithEmailAndPassWord(BuildContext context) async{
    try{
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPass.text
      );
      onClickLogin(context);
    }on FirebaseAuthException catch (e){
        print("dăng nhập thất bại");
    }
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
              'Đăng Nhập',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("Welcome"),

            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _controllerEmail,
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
                controller: _controllerPass,
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
              child: CheckboxListTile(
                title: const Text('Ghi nhớ đăng nhập'),
                value: _isRemember,
                onChanged: (bool? value){
                  setState(() {
                    _isRemember = !_isRemember;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  signInWithEmailAndPassWord(context);
                  remember();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(200, 30)
                ),
                child: const Text(
                  'Đăng Nhập',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            RichText(text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: 'Bạn chưa có tài khoản? '),
                  TextSpan(text: 'Đăng ký',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      onClickSignUp(context);
                    },
                  ),
                ]
            )),

          ],
        ),
      ),
    );
  }

}
