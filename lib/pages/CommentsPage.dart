import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:buddiesgram/widgets/CImageWidget.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  const CommentsPage(
      {Key key, this.postId, this.postOwnerId, this.postImageUrl})
      : super(key: key);
  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId, postOwnerId: postOwnerId, postImageUrl: postImageUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  TextEditingController commentsTextEditingController = TextEditingController();

  CommentsPageState({this.postId, this.postOwnerId, this.postImageUrl});
  displayComents() {
    return StreamBuilder(
        stream: commentsRef
            .document(postId)
            .collection('comments')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, datasnapshot) {
          if (!datasnapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          datasnapshot.data.documents.forEach((document) {
            comments.add(Comment.fromDocument(document));
          });

          return ListView(children: comments);
        });
  }

  saveComment() {
    commentsRef.document(postId).collection('comments').add({
      'username': currentUser.username,
      'comment': commentsTextEditingController.text,
      'time': DateTime.now(),
      'url': currentUser.url,
      'userId': currentUser.id,
    });

    bool isNotpostOwner = postOwnerId != currentUser.id;
    if (isNotpostOwner) {
      activityFeedRef.document(postOwnerId).collection('feedItems').add({
        'type': "comment",
        'commentData': DateTime.now(),
        'postId': postId,
        'userId': currentUser.id,
        'username': currentUser.username,
        'userProFileImage': currentUser.url,
        'url': postImageUrl
      });
    }
    commentsTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Coments"),
      body: Column(
        children: [
          Expanded(child: displayComents()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentsTextEditingController,
              decoration: InputDecoration(
                labelText: "Comment... ",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            trailing: OutlineButton(
              onPressed: saveComment,
              borderSide: BorderSide.none,
              child: Text(
                "Send",
                style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;

  const Comment(
      {Key key,
      this.userName,
      this.userId,
      this.url,
      this.comment,
      this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      userName: documentSnapshot['username'],
      userId: documentSnapshot['userId'],
      url: documentSnapshot['url'],
      comment: documentSnapshot['comment'],
      timestamp: documentSnapshot['time'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Container(
        color: Colors.white10,
        child: Column(
          children: [
            ListTile(
              title: Text(
                userName + ' : ' + comment,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(
                'Time : ' +
                    tAgo.format(
                      timestamp.toDate(),
                    ),
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
