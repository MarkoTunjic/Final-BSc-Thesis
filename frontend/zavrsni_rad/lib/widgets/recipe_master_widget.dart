import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/models/recipe_master.dart';
import '../models/constants/constants.dart' as constants;
import '../screens/login_screen.dart';
import '../utilities/global_variables.dart' as globals;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../models/constants/shared_preferences_keys.dart' as keys;
import '../utilities/shared_preferences_helper.dart';

class RecipeMasterWidget extends StatefulWidget {
  final RecipeMaster recipe;
  final void Function() onDelete;
  const RecipeMasterWidget(
      {Key? key, required this.recipe, required this.onDelete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecipeMasterWidgetState();
  }
}

class _RecipeMasterWidgetState extends State<RecipeMasterWidget> {
  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.recipe.user.profilePicture),
              ),
            ),
            Text(
              widget.recipe.user.username,
              style: const TextStyle(color: constants.darkBlue),
            ),
          ],
        ),
        Stack(
          children: [
            ClipRRect(
              child: Image.network(
                widget.recipe.coverPicture,
                fit: BoxFit.cover,
                height: availableWidth / 2 - 10,
                width: availableWidth / 2 - 10,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            globals.loggedInUser != null
                ? Positioned(
                    child: Container(
                      child: Mutation(
                        builder: (runMutation, result) => IconButton(
                          onPressed: () {
                            setState(() {
                              widget.recipe.isLikedByCurrentUser =
                                  !widget.recipe.isLikedByCurrentUser;
                            });
                            runMutation({
                              "userId": globals.loggedInUser!.id,
                              "recipeId": widget.recipe.id,
                              "state": widget.recipe.isLikedByCurrentUser,
                            });
                          },
                          icon: widget.recipe.isLikedByCurrentUser
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border_outlined,
                                  color: Colors.white),
                        ),
                        options: MutationOptions(
                            document: gql(mutations.editFavorite),
                            onCompleted: (result) {
                              if (result == null) return;
                              Fluttertoast.showToast(
                                msg: widget.recipe.isLikedByCurrentUser
                                    ? "Added to favorites"
                                    : "Removed from favorites", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity:
                                    ToastGravity.BOTTOM, // location// duration
                              );
                            },
                            onError: (error) {
                              if (error!.graphqlErrors[0].message
                                      .split(":")[1]
                                      .trim()
                                      .toLowerCase() ==
                                  "access is denied") {
                                SharedPreferencesHelper.removeSharedPreference(
                                    keys.token);
                                SharedPreferencesHelper.removeSharedPreference(
                                    keys.user);
                                globals.loggedInUser = null;
                                globals.token = null;
                                Future.microtask(
                                  () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => const LoginScreen(
                                          error: "Session expired.")),
                                    ),
                                  ),
                                );
                              }
                              Fluttertoast.showToast(
                                msg: "Something went wrong", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity:
                                    ToastGravity.BOTTOM, // location// duration
                              );
                              setState(() {
                                widget.recipe.isLikedByCurrentUser =
                                    !widget.recipe.isLikedByCurrentUser;
                              });
                            }),
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(182, 158, 158, 158),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.all(5),
                    ),
                    right: 0,
                  )
                : Container(),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                  child: Text(
                    widget.recipe.recipeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.visible,
                  ),
                  width: MediaQuery.of(context).size.width / 3 - 20),
            ),
            (widget.recipe.user.id == globals.loggedInUser?.id ||
                    globals.loggedInUser?.role == "MODERATOR")
                ? Mutation(
                    options: MutationOptions(
                      document: gql(mutations.deleteRecipe),
                      onCompleted: (result) {
                        if (result == null) return;
                        widget.onDelete();
                        Fluttertoast.showToast(
                          msg: "Recipe successfully deleted", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.BOTTOM, // location// duration
                        );
                      },
                      onError: (error) {
                        if (error!.graphqlErrors[0].message
                                .split(":")[1]
                                .trim()
                                .toLowerCase() ==
                            "access is denied") {
                          SharedPreferencesHelper.removeSharedPreference(
                              keys.token);
                          SharedPreferencesHelper.removeSharedPreference(
                              keys.user);
                          globals.loggedInUser = null;
                          globals.token = null;
                          Future.microtask(
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const LoginScreen(
                                    error: "Session expired.")),
                              ),
                            ),
                          );
                        }
                        Fluttertoast.showToast(
                          msg: "Something went wrong", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.BOTTOM, // location// duration
                        );
                      },
                    ),
                    builder: (runMutation, result) {
                      return IconButton(
                        onPressed: () {
                          runMutation({"recipeId": widget.recipe.id});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      );
                    },
                  )
                : Container(),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        Row(
          children: [
            Text(
              widget.recipe.averageRating.toStringAsFixed(1),
              style: const TextStyle(color: constants.darkBlue),
            ),
            const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            const Icon(
              Icons.circle,
              size: 10,
              color: constants.grey,
            ),
            Text(
              " >" + widget.recipe.cookingDuration.toString() + "mins",
              style: const TextStyle(color: constants.darkBlue),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
