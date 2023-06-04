import 'dart:io';
import 'package:demo/Firebase/user_repository.dart';
import 'package:demo/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}
class EditProfileState extends State<EditProfileScreen> {
  TextEditingController _textName = TextEditingController();
  TextEditingController _textDate = TextEditingController();
  File? image;
  UserModel userModel = UserModel(uid: '', name: '', email: '', avatar: '', date: '', match: [], wait: [], request: []);

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Xử lý ảnh đã chọn ở đây
        // Ví dụ: hiển thị ảnh trong một ImageView
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      print('$e');
    }
  }
  Future<void> fetchData() async {
    try {
     await UserRepository().getUser().then((value) =>
         setState(() {
           userModel = value!;
           _textName.text = userModel!.name ;
           _textDate.text = userModel!.date;
         })
     );
    } catch (error) {
      print('Lỗi khi lấy dữ liệu người dùng5: $error');
    }
  }


  Future<void> updateProfile() async {
    try {
      String url='';
      if(image == null){
        url = userModel!.avatar;
      }else{
        DateTime time = DateTime.now();
        UploadTask uploadTask = FirebaseStorage.instance.ref().child('images$time').putFile(image!);
        TaskSnapshot snapshot = await uploadTask;
        url = await snapshot.ref.getDownloadURL();
      }
      UserRepository().updateUser(url, _textName.text, _textDate.text);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Lưu thành công'),
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
    } catch (e) {
      print('Upload error: $e');// Xử lý lỗi tải lên ở đây
    }
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              pickImage();
            },
            child: ClipOval(
              child: SizedBox(
                width: 200,
                height: 200,
                child: image != null ? Image.file(image!, fit: BoxFit.cover)
                    : CircleAvatar(child:userModel.avatar != ""
                    ? Image.network(userModel!.avatar, width: 200, height: 200, fit: BoxFit.cover,)
                    : const CircleAvatar(child: Icon(CupertinoIcons.person)) ,
                ),
              ),
            ),
          ),
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
              controller: _textDate,
              decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
              style: const TextStyle(
                fontSize: 18, // Đặt kích thước font chữ cho text
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              updateProfile();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 30)),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
