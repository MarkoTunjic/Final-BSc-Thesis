import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/screens/recipe_screen.dart';

import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_querys.dart' as querys;
import '../utilities/global_variables.dart' as globals;
import '../models/constants/shared_preferences_keys.dart' as keys;
import '../models/filter.dart';
import '../models/recipe_master.dart';
import '../utilities/shared_preferences_helper.dart';
import '../widgets/filter_widget.dart';
import '../widgets/menu_widget.dart';
import '../widgets/pagination_widget.dart';
import '../widgets/recipe_master_widget.dart';
import 'login_screen.dart';

class ApproovalScreen extends StatefulWidget {
  final int selected;
  const ApproovalScreen({Key? key, required this.selected}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ApproovalScreenState();
  }
}

class _ApproovalScreenState extends State<ApproovalScreen> {
  int currentIndex = 1;
  Filter filter = Filter(index: 1);
  late ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    super.initState();
    HttpLink? link;
    if (globals.token != null) {
      link = HttpLink(constants.apiLink,
          defaultHeaders: {"Authorization": "Bearer " + globals.token!});
    }
    client = ValueNotifier(
      GraphQLClient(
        link: link ?? constants.api,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  document: gql(querys.notApproovedRecipes),
                  variables: {"filter": filter.toJson()},
                  fetchPolicy: FetchPolicy.networkOnly,
                ),
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    if (result.exception!.graphqlErrors[0].message
                            .split(":")[1]
                            .trim()
                            .toLowerCase() ==
                        "access is denied") {
                      SharedPreferencesHelper.removeSharedPreference(
                          keys.token);
                      SharedPreferencesHelper.removeSharedPreference(keys.user);
                      globals.loggedInUser = null;
                      globals.token = null;
                      Future.microtask(
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) =>
                                const LoginScreen(error: "Session expired.")),
                          ),
                        ),
                      );
                    }
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  currentIndex =
                      result.data?["notApprovedRecipes"]["currentIndex"];

                  List<dynamic> rawRecipes =
                      result.data?["notApprovedRecipes"]["recipes"];

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
                            ).then((value) => refetch!());
                          },
                        ),
                      )
                      .toList();
                  int numberOfPages =
                      result.data?["notApprovedRecipes"]?["numberOfPages"];
                  return Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          leading: Container(),
                          floating: true,
                          flexibleSpace: FilterWidget(
                            showFilterIcon: false,
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
                                pageChange: (pageIndex) {
                                  filter.index = pageIndex;
                                  fetchMore!(opts);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              MenuWidget(
                selected: widget.selected,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}
