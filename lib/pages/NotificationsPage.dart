import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/pages/PostScreenPage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as tAgo;

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
          builder: (context, snap) {
            if (snap.hasData) {
              return ListView(
                children: snap.data,
              );
            } else {
              return circularProgress();
            }
          },
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
      notificationsItems.add(NotificationsItem.fromDocument(element));
    });
    return notificationsItems;
  }
}

String notificationItemText;
Widget mediaPreview;

class NotificationsItem extends StatelessWidget {
  final String username;
  final String commentData;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final String type;
  final Timestamp timestamp;

  const NotificationsItem(
      {Key key,
      this.username,
      this.commentData,
      this.postId,
      this.userId,
      this.userProfileImg,
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
      userProfileImg: documentSnapshot['userProfileImg'],
      timestamp: documentSnapshot['time'],
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPriview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: "  $notificationItemText"),
                  ]),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  profileId: userId,
                ),
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            tAgo.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }

  configureMediaPriview(BuildContext context) {
    if (type == 'comment' || type == 'like') {
      mediaPreview = GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreenPage(
                      postId: postId,
                      userId: userId,
                    ))),
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(url),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text("");
    }
    if (type == 'like') {
      notificationItemText = 'Liked youre post';
    } else if (type == 'comment') {
      notificationItemText = 'Replied:' + commentData;
    } else if (type == 'follow') {
      notificationItemText = 'Start following you';
    } else {
      notificationItemText = 'Error ,UnKnown type=$type';
    }
  }
}
