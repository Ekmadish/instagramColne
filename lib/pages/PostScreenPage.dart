import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';

class PostScreenPage extends StatelessWidget {
  final String postId, userId;

  const PostScreenPage({Key key, this.postId, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsReference
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .get(),
      // initialData: InitialData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Post post = Post.fromDocument(snapshot.data);

        return Center(
          child: Scaffold(
            appBar: header(context, title: post.descrption),
            body: ListView(
              children: [
                Container(
                  child: post,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
