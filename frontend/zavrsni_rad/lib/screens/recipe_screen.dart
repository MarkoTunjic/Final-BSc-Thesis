import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:zavrsni_rad/models/recipe_detail.dart';
import 'package:zavrsni_rad/widgets/comments_widget.dart';
import 'package:zavrsni_rad/widgets/images_widget.dart';
import 'package:zavrsni_rad/widgets/ingredients_widget.dart';
import 'package:zavrsni_rad/widgets/multiline_input_field_widget.dart';
import 'package:zavrsni_rad/widgets/steps_widget.dart';
import 'package:zavrsni_rad/widgets/videos_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_querys.dart' as querys;

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecipeScreenState();
  }
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: constants.api,
        cache: GraphQLCache(
          store: HiveStore(),
        ),
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

            RecipeDetail recipe =
                RecipeDetail.fromJson(result.data?["singleRecipe"]);

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
                          recipe.coverPicture,
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
                              recipe.recipeName,
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
                              onPressed: () {},
                            ),
                            Text(
                              recipe.averageRating.toStringAsPrecision(1),
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
                                  recipe.cookingDuration.toString() +
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
                                  backgroundImage:
                                      NetworkImage(recipe.user.profilePicture),
                                ),
                                Text(
                                  " " + recipe.user.username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: constants.darkBlue,
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          onTap: () {},
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
                          recipe.description,
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
                        IngredientsWidget(ingredients: recipe.ingredients),
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
                        StepsWidget(steps: recipe.steps),
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
                        VideosWidget(videos: recipe.videos),
                        ImagesWidget(images: recipe.images),
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
                        Row(
                          children: [
                            MultilineInputFieldWidget(
                              hintText: "Add comment\n\n",
                              width: MediaQuery.of(context).size.width * 3 / 4,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.send,
                                color: constants.green,
                                size: 30,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                        ...CommentsWidget.getWidgets(recipe.comments),
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
