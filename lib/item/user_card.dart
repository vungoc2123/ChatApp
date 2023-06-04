import 'package:demo/Firebase/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class UserCard extends StatefulWidget {
  UserModel user;

  UserCard(this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserCardState();
  }
}

class UserCardState extends State<UserCard> {
  int i = 0;

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

  Future<void> fetchData() async {
    try {
      int value = await UserRepository().filter(widget.user.uid);
      setState(() {
        i = value;
      });
    } catch (error) {
      print('Lỗi khi lấy dữ liệu người dùng5: $error');
    }
  }

  Widget filter() {
    if (i == 1) {
      return _buttonCancel();
    }
    if (i == 2) {
      return _buttonConfirmOrCancel();
    }
    if (i == 3) {
      return _buttonUnMatch();
    }
    return _buttonMatch();
  }

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      return Card();
    }
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: widget.user.avatar != ''
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.avatar!),
                      radius: 25,
                    )
                  : const CircleAvatar(child: Icon(CupertinoIcons.person)),
              title: Text(widget.user.name),
              subtitle: const Text(
                "Hận đời vô đối",
                maxLines: 1,
              ),
              trailing: filter(),
            )));
  }

  Widget _buttonMatch() {
    return ElevatedButton(
      onPressed: () {
        UserRepository().match(widget.user.uid);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
      ),
      child: const Text('Match'),
    );
  }

  Widget _buttonUnMatch() {
    return ElevatedButton(
      onPressed: () {
        UserRepository().unMatch(widget.user.uid);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white24,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
      ),
      child: const Text('UnMatch'),
    );
  }

  Widget _buttonCancel() {
    return ElevatedButton(
      onPressed: () {
        UserRepository().cancel(widget.user.uid);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
      ),
      child: const Text('Cancel'),
    );
  }

  Widget _buttonConfirmOrCancel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            UserRepository().cancel(widget.user.uid);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8), // Khoảng cách giữa hai nút
        ElevatedButton(
          onPressed: () {
            UserRepository().confirmMatch(widget.user.uid);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
