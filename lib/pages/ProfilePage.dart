import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/EditProfilePage.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userProFileId;

  const ProfilePage({Key key, this.userProFileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = curentUser.id;
  FutureBuilder createProFileView() {
    return FutureBuilder(
        future: usersReference.document(widget.userProFileId).get(),
        builder: (context, datasnapshot) {
          if (!datasnapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(datasnapshot.data);
          return Padding(
            padding: EdgeInsets.all(17),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(user.url),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              createColums("Post", 0),
                              createColums("Followers", 0),
                              createColums("Following", 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              createButton(),
                            ],
                          ),
                        ],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProFileId;

    if (ownProfile) {
      return createButtonAndTitle(
          title: "Edit Profile", perFormFunction: editUserProfile);
    }
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditProfilePage(currentOnlineUserId: currentOnlineUserId),
        ));
  }

  createButtonAndTitle({String title, Function perFormFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: FlatButton(
        child: Container(
          width: 245,
          height: 26,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Column createColums(String title, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Profile"),
      body: ListView(
        children: [
          createProFileView(),
        ],
      ),
    );
  }
}
