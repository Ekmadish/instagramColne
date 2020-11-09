import 'package:buddiesgram/pages/PostScreenPage.dart';
import 'package:flutter/material.dart';
import 'PostWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PostScreenPage(postId: post.postId, userId: post.ownerId),
          )),
      child: Image.network(post.url),
    );
  }
}
