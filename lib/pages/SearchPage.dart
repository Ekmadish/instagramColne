import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

User demo;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResult;

  emptyTextForm() {
    setState(() {
      searchTextEditingController.clear();
    });
  }

  cotrollSearching(String str) {
    Future<QuerySnapshot> allUser = usersReference
        .where("username", isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      futureSearchResult = allUser;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        controller: searchTextEditingController,
        style: TextStyle(fontSize: 24, color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search User",
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: emptyTextForm),
        ),
        onFieldSubmitted: cotrollSearching,
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.deck,
              color: Colors.white,
            ),
            onPressed: printsomething)
      ],
    );
  }

  printsomething() {
    print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww/nsssssssswwwwww    " +
        demo.toString());
  }

  Container displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(
              Icons.group,
              color: Colors.black54,
              size: 200,
            ),
            Text(
              "Search User Page",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 48),
            )
          ],
        ),
      ),
    );
  }

  displayUserScreen() {
    return FutureBuilder(builder: (context, datasnapshot) {
      if (!datasnapshot.hasData) {
        return circularProgress();
      }
      List<UserResult> searchUserResult = [];
      datasnapshot.data.documents.forEach((document) {
        User eachUser = User.fromDocument(document);
        UserResult userResult = UserResult(eachUser);
        searchUserResult.add(userResult);
      });
      return ListView(
        children: searchUserResult,
      );
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchPageHeader(),
      body: futureSearchResult == null
          ? displayNoSearchResultScreen()
          : displayUserScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;

  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    demo = eachUser;
    return Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => print("Taped"),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(
                  eachUser.profileName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  eachUser.username,
                  style: TextStyle(color: Colors.black, fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
