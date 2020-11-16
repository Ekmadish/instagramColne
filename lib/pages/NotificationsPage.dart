import 'dart:html';

import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Notificatio"),
      body: Container(
        child: FutureBuilder(
          builder: null,
          future: receivenotfication(),
        ),
      ),
    );
  }

  receivenotfication() async {
    QuerySnapshot querySnapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('time', descending: true)
        .limit(60)
        .getDocuments();

    List<NotificationsItem> notificationsItems = [];

    querySnapshot.documents.forEach((element) {
      notificationsItems.add(NotificationsItem.fromDocument(document));
    });
  }
}

class NotificationsItem extends StatelessWidget {
  final String username;
  final String commentData;
  final String postId;
  final String userId;
  final String userProFileImage;
  final String url;
  final String type;
  final Timestamp timestamp;

  const NotificationsItem(
      {Key key,
      this.username,
      this.commentData,
      this.postId,
      this.userId,
      this.userProFileImage,
      this.url,
      this.type,
      this.timestamp})
      : super(key: key);

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NotificationsItem(
      username: documentSnapshot['username'],
      type: documentSnapshot['type'],
      commentData: documentSnapshot['commentData'],
      url: documentSnapshot['url'],
      postId: documentSnapshot['postId'],
      userId: documentSnapshot['userId'],
      userProFileImage: documentSnapshot['userProFileImage'],
      timestamp: documentSnapshot['time'],
    );
  }

  @override
  Widget build(BuildContext context) {}
}
