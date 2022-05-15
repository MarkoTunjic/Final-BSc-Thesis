import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/screens/login_screen.dart';
import 'package:zavrsni_rad/utilities/shared_preferences_helper.dart';
import 'package:zavrsni_rad/widgets/menu_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_querys.dart' as querys;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../models/constants/shared_preferences_keys.dart' as keys;
import '../models/user.dart';
import '../utilities/global_variables.dart' as globals;

import '../models/filter.dart';
import '../widgets/filter_widget.dart';
import '../widgets/pagination_widget.dart';

class UsersScreen extends StatefulWidget {
  final int selected;
  const UsersScreen({Key? key, required this.selected}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UsersScreenState();
  }
}

class _UsersScreenState extends State<UsersScreen> {
  int currentIndex = 1;
  Filter filter = Filter(index: 1);
  List<User> users = [];
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
                  document: gql(querys.users),
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
                  currentIndex = result.data?["users"]["currentIndex"];

                  List<dynamic> rawUsers = result.data?["users"]["users"];

                  users = rawUsers.map((e) => User.fromJSON(e)).toList();
                  List<Widget> userWidgets = users
                      .map(
                        (e) => Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(e.profilePicture),
                              radius: MediaQuery.of(context).size.width / 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(e.username),
                              ),
                            ),
                            Mutation(
                              options: MutationOptions(
                                document: gql(mutations.changeBanStatus),
                                onCompleted: (result) {
                                  if (result == null) return;
                                  Fluttertoast.showToast(
                                    msg: e.isBanned!
                                        ? "Successfully banned"
                                        : "Successfully unbanned", // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.BOTTOM, // location
                                  );
                                  refetch!();
                                },
                                onError: (error) {
                                  if (error!.graphqlErrors[0].message
                                          .split(":")[1]
                                          .trim()
                                          .toLowerCase() ==
                                      "access is denied") {
                                    SharedPreferencesHelper
                                        .removeSharedPreference(keys.token);
                                    SharedPreferencesHelper
                                        .removeSharedPreference(keys.user);
                                    globals.loggedInUser = null;
                                    globals.token = null;
                                    Future.microtask(
                                      () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) =>
                                              const LoginScreen(
                                                  error: "Session expired.")),
                                        ),
                                      ),
                                    );
                                  }
                                  Fluttertoast.showToast(
                                    msg: "Something went wrong", // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.BOTTOM, // location
                                  );
                                },
                              ),
                              builder: (runMutation, result) {
                                return InkWell(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: e.isBanned!
                                          ? const Text(
                                              "Unban",
                                              textAlign: TextAlign.center,
                                            )
                                          : const Text(
                                              "Ban",
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: e.isBanned!
                                            ? constants.green
                                            : constants.errorRed,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      e.isBanned = !e.isBanned!;
                                      runMutation({
                                        "userId": e.id,
                                        "banStatus": e.isBanned
                                      });
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                      .toList();
                  int numberOfPages = result.data?["users"]?["numberOfPages"];
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
                          childAspectRatio: 1 / 1.3,
                          children: userWidgets,
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate.fixed(
                            [
                              users.isEmpty
                                  ? const Text(
                                      "No results",
                                      textAlign: TextAlign.center,
                                    )
                                  : Container(),
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
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}
