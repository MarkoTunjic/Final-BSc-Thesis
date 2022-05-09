import 'package:flutter/material.dart';
import 'package:zavrsni_rad/models/comment.dart';

import '../models/constants/constants.dart' as constants;

class CommentsWidget {
  static List<Widget> getWidgets(List<Comment> comments) {
    List<Widget> widgets = [];
    for (Comment comment in comments) {
      widgets.add(_CommentWidget(comment: comment));
    }
    return widgets;
  }
}

class _CommentWidget extends StatelessWidget {
  final Comment comment;
  const _CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: constants.inputBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(comment.user.profilePicture),
                  ),
                ),
                Text(
                  comment.user.username,
                  style: const TextStyle(
                    fontSize: 17,
                    color: constants.darkBlue,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                comment.commentText,
                style: const TextStyle(
                  fontSize: 15,
                  color: constants.darkBlue,
                ),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
