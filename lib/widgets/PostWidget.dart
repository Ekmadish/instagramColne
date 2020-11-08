import 'dart:ffi';
import 'dart:html';

import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/CImageWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final dynamic likes;
  final String username;
  final String descrption;
  final String loaction;
  final String url;

  Post(
      {Key key,
      this.postId,
      this.ownerId,
      this.likes,
      this.username,
      this.descrption,
      this.loaction,
      this.url})
      : super(key: key);

  factory Post.fromDocumentsnapShot(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      likes: documentSnapshot['likes'],
      username: documentSnapshot['username'],
      descrption: documentSnapshot['descrption'],
      loaction: documentSnapshot['loaction'],
      url: documentSnapshot['url'],
    );
  }

  int getTotalnomberlikes(likes) {
    if (likes == null) {
      return 0;
    }
    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });

    return counter;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        likes: this.likes,
        username: this.username,
        descrption: this.descrption,
        location: this.loaction,
        url: this.url,
        likeCount: getTotalnomberlikes(this.likes),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  Map likes;
  final String username;
  final String descrption;
  final String loaction;
  final String url;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  final String ucrrentOnlineUserId = curentUser?.id;

  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.descrption,
    this.loaction,
    this.url,
    this.likeCount,
    location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          postHeader(),
          postPicture(),
          postFooter(),
        ],
      ),
    );
  }

  postHeader() async {
    FutureBuilder(
      builder: (context, datasnapShot) {
        if (!datasnapShot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(datasnapShot.data);
        bool isPostowner = ucrrentOnlineUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.url),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () {},
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            loaction,
            style: TextStyle(color: Colors.white),
          ),
          trailing: isPostowner
              ? IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {})
              : Text(""),
        );
      },
      future: usersReference.document(ownerId).get(),
    );
  }

  postPicture() {
    return GestureDetector(
      onDoubleTap: () {},
      child: Stack(
        children: [
          cachedNetworkImage(url),
        ],
      ),
    );
  }

  postFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40, left: 20),
            ),
            GestureDetector(
              child: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 28,
                ),
                onPressed: () {},
              ),
            ),
            GestureDetector(
              child: IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {},
              ),
            ),
          ],
        )
      ],
    );
  }
}
