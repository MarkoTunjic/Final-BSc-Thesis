import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavrsni_rad/models/user.dart';
import 'package:zavrsni_rad/widgets/green_button_widget.dart';
import 'package:zavrsni_rad/widgets/input_field_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/shared_preferences_keys.dart' as keys;
import '../models/constants/graphql_mutations.dart' as mutations;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  @override
  Widget build(BuildContext context) {
    String? identifier;
    String? password;
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
        body: Stack(
          children: [
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
                          icon: const Icon(Icons.email),
                        ),
                        Padding(
                          child: InputFieldWidget(
                            hintText: "Password",
                            onSaved: (newValue) => password = newValue!,
                            obscure: true,
                            icon: const Icon(Icons.lock),
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Skip for now"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(constants.grey),
                          ),
                        ),
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
                          String token = resultData["login"]["token"];
                          User user =
                              User.fromJSON(resultData["login"]["user"]);

                          _prefs!.setString(keys.token, token);
                          _prefs!
                              .setString(keys.user, jsonEncode(user.toJson()));
                        }),
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
                          },
                          text: "Login");
                    },
                  ),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {},
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