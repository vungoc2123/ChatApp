import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/layout/chat_screen.dart';
import 'package:demo/item/chat_user_card.dart';
import 'package:demo/layout/edit_profile_screen.dart';
import 'package:demo/layout/home_screen.dart';
import 'package:demo/item/message_card.dart';
import 'package:demo/layout/profile_screen.dart';
import 'package:demo/layout/signup.dart';
import 'package:demo/item/user_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demo/layout/login.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SafeArea(
      child: Scaffold(
        body: LoginPage(),
        // appBar: AppBar(
        //   backgroundColor: Colors.blue,
        //   title:const Text("ngoc"),
        // ),
        // body: const Center(child: Text('hello world'))
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyList extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var x = 10;
  Map<String, dynamic> data = {
    'name': 'John',
    'age': 30,
  };
  CollectionReference reference = FirebaseFirestore.instance.collection('users');
  List<Station> stations = [
    Station(1, "Tram 01", "publish", true),
    Station(2, "Tram 02", "publish", true),
    Station(3, "Tram 03", "publish", true),
    Station(4, "Tram 04", "publish", true),
  ];
  @override
  Widget build(BuildContext context) {
    reference.add(data);

    return ListView.builder(itemCount: stations.length,itemBuilder: (context,index){
      final item = stations[index];
      return ListTile(
            leading: const Icon(Icons.online_prediction),
            title: Text(item.name),
            trailing: const Icon(Icons.public),
        );
    });
  }
}



class Station {
  int id;
  String name;
  String type;
  bool status;

  Station(this.id, this.name, this.type, this.status);
}





