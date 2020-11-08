import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/EditProfilePage.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/PostTileWidget.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userProFileId;

  const ProfilePage({Key key, this.userProFileId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];

  String postOrianTation = 'grid';
  @override
  void initState() {
    super.initState();
    getOwnPosts();
  }

  final String currentOnlineUserId = currentUser.id;
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 13),
                  child: Text(
                    user.username,
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 2.5, fontSize: 12),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    user.profileName,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    user.bio,
                    style: TextStyle(color: Colors.white54, fontSize: 17),
                  ),
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
      ),
    );
  }

  Container createButtonAndTitle({String title, Function perFormFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: FlatButton(
        onPressed: perFormFunction,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: 245,
          height: 35,
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
          Divider(),
          proFileImages(),
          Divider(
            height: 0.0,
          ),
          displayPost(),
        ],
      ),
    );
  }

  getOwnPosts() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await postsReference
        .document(widget.userProFileId)
        .collection("userPosts")
        .orderBy("time", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents
          .map((snap) => Post.fromDocument(snap))
          .toList();
    });
  }

  displayPost() {
    if (loading) {
      return circularProgress();
    } else if (postsList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 200,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                "No Data",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    } else if (postOrianTation == 'grid') {
      List<GridTile> gridTile = [];

      postsList.forEach(
        (eachPost) {
          gridTile.add(
            GridTile(
              child: PostTile(
                post: eachPost,
              ),
            ),
          );
        },
      );
      return GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: gridTile);
    } else if (postOrianTation == 'list') {}

    return Column(children: postsList);
  }

  proFileImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.grid_on),
          color: postOrianTation == 'grid'
              ? Theme.of(context).primaryColor
              : Colors.grey,
          onPressed: setOriantation('grid'),
        ),
        IconButton(
          icon: Icon(Icons.list),
          color: postOrianTation == 'List'
              ? Theme.of(context).primaryColor
              : Colors.grey,
          onPressed: setOriantation('list'),
        ),
      ],
    );
  }

  setOriantation(String oriantation) {
    setState(() {
      this.postOrianTation = oriantation;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
