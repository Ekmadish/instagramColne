import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  const EditProfilePage({Key key, this.currentOnlineUserId}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _proFileNameTextEditingController =
      TextEditingController();
  TextEditingController _bioTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _proFileName = true;
  bool _bio = true;
  @override
  void initState() {
    super.initState();
    getAndDisplayUserInfo();
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot =
        await usersReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);
    _proFileNameTextEditingController.text = user.profileName;
    _bioTextEditingController.text = user.bio;

    setState(() {
      loading = false;
    });
  }

  upDateUserData() {
    setState(() {
      _proFileNameTextEditingController.text.trim().length < 3 ||
              _proFileNameTextEditingController.text.isEmpty
          ? _proFileName = false
          : _proFileName = true;

      _bioTextEditingController.text.trim().length > 50 ||
              _bioTextEditingController.text.isEmpty
          ? _bio = false
          : _bio = true;

      if (_bio && _proFileName) {
        usersReference.document(widget.currentOnlineUserId).updateData({
          "profileName": _proFileNameTextEditingController.text,
          "bio": _bioTextEditingController.text,
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Update SuccessFull",
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: loading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 7,
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: CachedNetworkImageProvider(user.url),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            createFroFileNameTextFiled(),
                            createFroFileBioTextFiled()
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 29, left: 50, right: 50),
                        child: RaisedButton(
                          onPressed: upDateUserData,
                          child: Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 50, left: 50),
                        child: RaisedButton(
                          color: Colors.red,
                          onPressed: () async {
                            await gSignIn.signOut().then((value) =>
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false));
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Column createFroFileNameTextFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "ProFile Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: _proFileNameTextEditingController,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              hintText: "Write Name ",
              hintStyle: TextStyle(color: Colors.white),
              errorText: _proFileName ? null : "ProFileName Short"),
        ),
      ],
    );
  }

  Column createFroFileBioTextFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            "Bio  ",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: _bioTextEditingController,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              hintText: "Write Bio   ",
              hintStyle: TextStyle(color: Colors.white),
              errorText: _bio ? null : "Bio Long "),
        ),
      ],
    );
  }
}
