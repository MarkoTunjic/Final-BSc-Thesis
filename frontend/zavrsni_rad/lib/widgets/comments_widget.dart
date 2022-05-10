import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/models/comment.dart';

import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../utilities/global_variables.dart' as globals;

class CommentsWidget {
  static List<Widget> getWidgets(
      List<Comment> comments, int authorId, void Function()? onDelete) {
    List<Widget> widgets = [];
    for (Comment comment in comments) {
      widgets.add(_CommentWidget(
        comment: comment,
        authorId: authorId,
        onDelete: onDelete,
      ));
    }
    return widgets;
  }
}

class _CommentWidget extends StatelessWidget {
  final Comment comment;
  final int authorId;
  final void Function()? onDelete;
  const _CommentWidget(
      {Key? key, required this.comment, required this.authorId, this.onDelete})
      : super(key: key);

  bool _showDelete() {
    if (globals.loggedInUser == null) return false;

    if (globals.loggedInUser!.role == "MODERATOR") return true;

    if (globals.loggedInUser!.id == authorId) return true;

    if (globals.loggedInUser!.id == comment.user.id) return true;

    return false;
  }

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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(comment.user.profilePicture),
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
                ),
                _showDelete()
                    ? Mutation(
                        options: MutationOptions(
                          document: gql(mutations.deleteComment),
                          onCompleted: (result) {
                            onDelete!();
                          },
                        ),
                        builder: (runMutation, result) {
                          return IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: constants.errorRed,
                            ),
                            onPressed: () {
                              runMutation({"commentId": comment.id});
                            },
                          );
                        },
                      )
                    : Container(),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
