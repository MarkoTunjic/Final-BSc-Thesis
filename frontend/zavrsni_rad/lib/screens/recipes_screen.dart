import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/models/filter.dart';
import 'package:zavrsni_rad/models/recipe_master.dart';
import 'package:zavrsni_rad/screens/recipe_screen.dart';
import 'package:zavrsni_rad/widgets/filter_widget.dart';
import 'package:zavrsni_rad/widgets/menu_widget.dart';
import 'package:zavrsni_rad/widgets/pagination_widget.dart';
import 'package:zavrsni_rad/widgets/recipe_master_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_querys.dart' as querys;
import '../utilities/global_variables.dart' as globals;

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecipesScreenState();
  }
}

class _RecipesScreenState extends State<RecipesScreen> {
  int currentIndex = 0;
  Filter filter = Filter(
      index: 0, mustNotContaintIngredients: [], canContainIngredients: []);
  AuthLink? authLink;

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
    FetchMoreOptions opts = FetchMoreOptions(
      variables: {"filter": filter},
      updateQuery: (Map<String, dynamic>? previousResultData,
          Map<String, dynamic>? fetchMoreResultData) {
        return fetchMoreResultData;
      },
    );
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(top: 50, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Query(
                options: QueryOptions(
                  document: gql(querys.recipes),
                  variables: {"filter": filter.toJson()},
                ),
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  currentIndex = result.data?["recipes"]["currentIndex"];

                  List<dynamic> rawRecipes = result.data?["recipes"]["recipes"];

                  List<RecipeMaster> recipes =
                      rawRecipes.map((e) => RecipeMaster.fromJson(e)).toList();
                  List<Widget> recipeWidgets = recipes
                      .map(
                        (e) => InkWell(
                          child: RecipeMasterWidget(
                            recipe: e,
                            onDelete: () {
                              fetchMore!(opts);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeScreen(
                                  id: e.id,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList();
                  int numberOfPages = result.data?["recipes"]?["numberOfPages"];
                  return Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          leading: Container(),
                          floating: true,
                          flexibleSpace: FilterWidget(
                            initialValue: filter.nameLike,
                            onChanged: (newValue) {
                              filter.nameLike = newValue;
                            },
                            onEditingcomplete: () => fetchMore!(opts),
                            filter: filter,
                            onSubmit: () {
                              fetchMore!(opts);
                            },
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 251, 249, 249),
                        ),
                        SliverGrid.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.8,
                          children: recipeWidgets,
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate.fixed(
                            [
                              PaginationWidget(
                                maxPages: numberOfPages,
                                currentPage: currentIndex,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              const MenuWidget(selected: 0)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}
