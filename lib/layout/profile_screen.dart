import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Firebase/user_repository.dart';
import 'package:demo/layout/edit_profile_screen.dart';
import 'package:demo/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  Stream<DocumentSnapshot> profileStream = Stream.empty();


  @override
  void initState() {
    super.initState();
    profileStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: profileStream,
            builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              var data = snapshot.data;
              UserModel userModel = UserModel.fromSnapshot(data!);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(height: 130, width: 130, child: ClipOval(child: userModel.avatar != ''
                        ? CircleAvatar(backgroundImage: NetworkImage(userModel.avatar!), radius: 25,)
                        : const CircleAvatar(child: Icon(CupertinoIcons.person)),

                          // Image.network(
                          //   userModel.avatar,
                          //   width: 200,
                          //   height: 200,
                          //   fit: BoxFit.cover,
                          // ),
                        )
                        //child: Icon(CupertinoIcons.person)
                        ),
                  ),
                  _textFieldWidget(userModel.name, userModel.email, userModel.date),
                ],
              );
            })
    );
  }

  Widget _textFieldWidget(String name, String email, String date) {
    return Column(
      children: [
        Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text("Name"),
              subtitle: Text(
                name,
                maxLines: 1,
              ),
            )),
        Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.email)),
              title: const Text("Email"),
              subtitle: Text(
                email,
                maxLines: 1,
              ),
            )),
        Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.calendar_month)),
              title: const Text("Date"),
              subtitle: Text(
                date,
                maxLines: 1,
              ),
            ))
      ],
    );
  }
}
