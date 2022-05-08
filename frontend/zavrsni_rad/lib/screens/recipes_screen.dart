import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/models/bloc_providers/ingredients_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/steps_provider.dart';
import 'package:zavrsni_rad/models/filter.dart';
import 'package:zavrsni_rad/models/recipe_master.dart';
import 'package:zavrsni_rad/screens/recipe_screen.dart';
import 'package:zavrsni_rad/widgets/filter_widget.dart';
import 'package:zavrsni_rad/widgets/menu_widget.dart';
import 'package:zavrsni_rad/widgets/pagination_widget.dart';
import 'package:zavrsni_rad/widgets/recipe_master_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_querys.dart' as querys;

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecipesScreenState();
  }
}

class _RecipesScreenState extends State<RecipesScreen> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    Filter filter = Filter(index: pageIndex);
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
        body: Padding(
          padding:
              const EdgeInsets.only(top: 50, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              const FilterWidget(),
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

                  List<dynamic> rawRecipes = result.data?["recipes"]["recipes"];

                  List<RecipeMaster> recipes =
                      rawRecipes.map((e) => RecipeMaster.fromJson(e)).toList();
                  int numberOfPages = result.data?["recipes"]?["numberOfPages"];
                  return Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: recipes.length % 2 == 0
                          ? recipes.length + 2
                          : recipes.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.7,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= recipes.length && index % 2 == 0) {
                          return PaginationWidget(maxPages: numberOfPages);
                        }
                        if (index >= recipes.length && index % 2 != 0) {
                          return Container();
                        }

                        return InkWell(
                          child: RecipeMasterWidget(recipe: recipes[index]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RecipeScreen(
                                  id: recipes[index].id,
                                ),
                              ),
                            );
                          },
                        );
                      },
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
