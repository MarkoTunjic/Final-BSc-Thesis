import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavrsni_rad/models/user.dart';
import 'package:zavrsni_rad/screens/recipes_screen.dart';
import 'package:zavrsni_rad/screens/register_screen.dart';
import 'package:zavrsni_rad/widgets/green_button_widget.dart';
import 'package:zavrsni_rad/widgets/input_field_widget.dart';
import '../models/bloc_providers/profile_picture_provider.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/shared_preferences_keys.dart' as keys;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../utilities/global_variables.dart' as globals;

class LoginScreen extends StatefulWidget {
  final String? error;
  const LoginScreen({Key? key, this.error}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPreferences? _prefs;
  String? _error;
  late ValueNotifier<GraphQLClient> client;
  bool _showProgressIndicator = false;

  @override
  void initState() {
    super.initState();
    _error = widget.error;
    SharedPreferences.getInstance().then((value) => _prefs = value);
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
    String? identifier;
    String? password;

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: Stack(
          children: [
            _showProgressIndicator
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Positioned(
              top: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  const Text(
                    "Welcome back!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const Text(
                    "\nPlease enter your account here:\n",
                    style: TextStyle(fontSize: 15, color: constants.grey),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputFieldWidget(
                          hintText: "E-mail or username",
                          onSaved: (newValue) => identifier = newValue!,
                          obscure: false,
                          width: MediaQuery.of(context).size.width - 20,
                          icon: const Icon(Icons.email),
                          type: TextInputType.text,
                        ),
                        Padding(
                          child: InputFieldWidget(
                            hintText: "Password",
                            onSaved: (newValue) => password = newValue!,
                            obscure: true,
                            icon: const Icon(Icons.lock),
                            width: MediaQuery.of(context).size.width - 20,
                            type: TextInputType.text,
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RecipesScreen(
                                  selcted: 0,
                                ),
                              ),
                            );
                          },
                          child: const Text("Skip for now"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(constants.grey),
                          ),
                        ),
                        _error != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                      color: constants.errorRed,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Column(
                children: [
                  Mutation(
                    options: MutationOptions(
                      document: gql(mutations.login),
                      onCompleted: (dynamic resultData) {
                        _showProgressIndicator = false;
                        if (resultData == null) return;
                        _error = null;
                        String token = resultData["login"]["token"];
                        User user = User.fromJSON(resultData["login"]["user"]);

                        _prefs!.setString(keys.token, token);
                        _prefs!.setString(keys.user, jsonEncode(user.toJson()));
                        globals.loggedInUser = user;
                        globals.token = token;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecipesScreen(
                              selcted: 0,
                            ),
                          ),
                        );
                      },
                      onError: (error) {
                        setState(() {
                          _error =
                              error!.graphqlErrors[0].message.split(":")[1];
                        });
                      },
                    ),
                    builder: (RunMutation runMutation, QueryResult? result) {
                      return GreenButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                          runMutation(
                            {
                              "identifier": identifier,
                              "password": password,
                            },
                          );
                          setState(() {
                            _showProgressIndicator = true;
                          });
                        },
                        text: "Login",
                      );
                    },
                  ),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<BlocProfilePicture>(
                                create: (_) => BlocProfilePicture(),
                                child: const RegisterScreen(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: constants.green),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
              bottom: 0,
            ),
          ],
          alignment: Alignment.center,
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
