import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:zavrsni_rad/models/recipe_detail.dart';
import 'package:zavrsni_rad/screens/recipes_screen.dart';
import 'package:zavrsni_rad/widgets/comments_widget.dart';
import 'package:zavrsni_rad/widgets/images_widget.dart';
import 'package:zavrsni_rad/widgets/ingredients_widget.dart';
import 'package:zavrsni_rad/widgets/multiline_input_field_widget.dart';
import 'package:zavrsni_rad/widgets/steps_widget.dart';
import 'package:zavrsni_rad/widgets/videos_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_querys.dart' as querys;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../utilities/global_variables.dart' as globals;

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecipeScreenState();
  }
}

class _RecipeScreenState extends State<RecipeScreen> {
  String? currentCommentText;
  late RecipeDetail currentRecipe;

  @override
  Widget build(BuildContext context) {
    HttpLink? link;
    if (globals.token != null) {
      link = HttpLink(constants.apiLink,
          defaultHeaders: {"Authorization": "Bearer " + globals.token!});
    }
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link ?? constants.api,
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: Query(
          options: QueryOptions(
            document: gql(querys.singleRecipe),
            variables: {"recipeId": widget.id},
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const CircularProgressIndicator();
            }

            currentRecipe = RecipeDetail.fromJson(result.data?["singleRecipe"]);

            Widget dialog = GraphQLProvider(
              client: client,
              child: Mutation(
                options: MutationOptions(
                    document: gql(mutations.addRatingAndComment),
                    onCompleted: (result) {
                      refetch!();
                    }),
                builder: (runMutation, result) {
                  return RatingDialog(
                    title: const Text(
                      "Rate this recipe",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    submitButtonText: "Submit",
                    onSubmitted: (value) {
                      runMutation({
                        "recipeId": currentRecipe.id,
                        "userId": globals.loggedInUser!.id,
                        "commentText": value.comment,
                        "ratingValue": value.rating
                      });
                    },
                    initialRating:
                        currentRecipe.ratingFromCurrentUser.toDouble(),
                    message: const Text(
                      'Tap a star to set your rating',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                },
              ),
            );

            return CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverAppBar(
                  leading: Container(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(128, 158, 158, 158),
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  pinned: false,
                  flexibleSpace: Stack(
                    children: [
                      FlexibleSpaceBar(
                        background: Image.network(
                          currentRecipe.coverPicture,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          child: const Icon(
                            Icons.remove,
                            size: 50,
                            color: Colors.grey,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                            color: Color.fromARGB(255, 251, 249, 249),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                        ),
                        bottom: 0,
                      ),
                    ],
                  ),
                  expandedHeight: MediaQuery.of(context).size.height / 3,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              currentRecipe.recipeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: constants.darkBlue,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              onPressed: globals.token != null
                                  ? () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => dialog,
                                      );
                                    }
                                  : null,
                            ),
                            Text(
                              currentRecipe.averageRating
                                  .toStringAsPrecision(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: constants.darkBlue,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Cooking ",
                              style: TextStyle(
                                fontSize: 20,
                                color: constants.darkBlue,
                              ),
                            ),
                            const Icon(
                              Icons.circle,
                              color: constants.grey,
                              size: 10,
                            ),
                            Text(
                              " > " +
                                  currentRecipe.cookingDuration.toString() +
                                  "mins",
                              style: const TextStyle(
                                fontSize: 20,
                                color: constants.darkBlue,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      currentRecipe.user.profilePicture),
                                ),
                                Text(
                                  " " + currentRecipe.user.username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: constants.darkBlue,
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipesScreen(
                                  authorId: currentRecipe.user.id,
                                  selcted: 0,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const Text(
                          "Description\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: constants.darkBlue,
                          ),
                        ),
                        Text(
                          currentRecipe.description,
                          style: const TextStyle(
                            fontSize: 20,
                            color: constants.darkBlue,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const Text(
                          "Ingredients\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: constants.darkBlue,
                          ),
                        ),
                        IngredientsWidget(
                            ingredients: currentRecipe.ingredients),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const Text(
                          "Steps\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: constants.darkBlue,
                          ),
                        ),
                        StepsWidget(steps: currentRecipe.steps),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const Text(
                          "Images and videos\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: constants.darkBlue,
                          ),
                        ),
                        currentRecipe.videos.isNotEmpty
                            ? VideosWidget(videos: currentRecipe.videos)
                            : const Padding(
                                child: Text("No videos available"),
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                        currentRecipe.images.isNotEmpty
                            ? ImagesWidget(images: currentRecipe.images)
                            : const Padding(
                                child: Text("No images available"),
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        const Text(
                          "Comments\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: constants.darkBlue,
                          ),
                        ),
                        globals.loggedInUser != null
                            ? Row(
                                children: [
                                  MultilineInputFieldWidget(
                                    hintText: "Add comment\n\n",
                                    width: MediaQuery.of(context).size.width *
                                        3 /
                                        4,
                                    initialValue: currentCommentText,
                                    onChanged: (newValue) =>
                                        currentCommentText = newValue,
                                  ),
                                  Mutation(
                                    builder: (runMutation, result) =>
                                        IconButton(
                                      onPressed: () {
                                        if (currentCommentText != null &&
                                            currentCommentText!.isNotEmpty) {
                                          runMutation({
                                            "recipeId": currentRecipe.id,
                                            "userId": globals.loggedInUser!.id,
                                            "commentText": currentCommentText!,
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: constants.green,
                                        size: 30,
                                      ),
                                    ),
                                    options: MutationOptions(
                                      document: gql(mutations.addComment),
                                      onCompleted: (result) {
                                        if (result == null) return;
                                        currentCommentText = null;
                                        refetch!();
                                      },
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                              )
                            : Container(),
                        ...CommentsWidget.getWidgets(currentRecipe.comments,
                            currentRecipe.user.id!, refetch)
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
