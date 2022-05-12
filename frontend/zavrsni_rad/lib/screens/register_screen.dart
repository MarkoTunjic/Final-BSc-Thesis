import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavrsni_rad/models/bloc_providers/profile_picture_provider.dart';
import 'package:zavrsni_rad/models/register_request.dart';
import 'package:zavrsni_rad/screens/recipes_screen.dart';
import 'package:zavrsni_rad/widgets/bloc_profile_picture_widget.dart';
import 'package:zavrsni_rad/widgets/green_button_widget.dart';
import 'package:zavrsni_rad/widgets/picture_picker_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../utilities/global_variables.dart' as globals;
import '../widgets/input_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? _error;
  String? _message;
  RegisterRequest request =
      RegisterRequest(username: "", eMail: "", password: "");

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
              child: Column(
                children: [
                  const Text(
                    "Welcome!",
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
                          hintText: "E-mail",
                          onSaved: (newValue) => request.eMail = newValue!,
                          obscure: false,
                          icon: const Icon(Icons.email),
                          width: MediaQuery.of(context).size.width - 20,
                          type: TextInputType.text,
                        ),
                        Padding(
                          child: InputFieldWidget(
                            hintText: "Username",
                            onSaved: (newValue) => request.username = newValue!,
                            obscure: false,
                            icon: const Icon(Icons.person),
                            width: MediaQuery.of(context).size.width - 20,
                            type: TextInputType.text,
                          ),
                          padding: const EdgeInsets.only(top: 10),
                        ),
                        Padding(
                          child: InputFieldWidget(
                            hintText: "Password",
                            onSaved: (newValue) => request.password = newValue!,
                            obscure: true,
                            icon: const Icon(Icons.lock),
                            width: MediaQuery.of(context).size.width - 20,
                            type: TextInputType.text,
                          ),
                          padding: const EdgeInsets.only(top: 10),
                        ),
                        Padding(
                          child: InputFieldWidget(
                            hintText: "Repeat password",
                            onSaved: (newValue) => request.password = newValue!,
                            obscure: true,
                            icon: const Icon(Icons.lock),
                            width: MediaQuery.of(context).size.width - 20,
                            type: TextInputType.text,
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        PicturePickerWidget(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              File file = File(image.path);
                              request.profilePicture =
                                  base64Encode(file.readAsBytesSync());
                              BlocProvider.of<BlocProfilePicture>(context)
                                  .add(ShowProfilePicture(image: file));
                              return;
                            }
                            request.profilePicture = null;
                            BlocProvider.of<BlocProfilePicture>(context)
                                .add(HideProfilePicture());
                          },
                          text: const Text(
                            "Choose profile picture (optional)",
                            style:
                                TextStyle(fontSize: 15, color: constants.grey),
                          ),
                          iconSize: 30,
                          radius: const Radius.circular(100),
                        ),
                        BlocBuilder<BlocProfilePicture, File?>(
                          builder: (context, state) {
                            return BlocProfilePictureWidget(image: state);
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
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
                                  ),
                                ),
                              )
                            : Container(),
                        _message != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  _message!,
                                  style: const TextStyle(
                                    color: constants.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              top: 50,
            ),
            Mutation(
              options: MutationOptions(
                document: gql(mutations.register),
                onCompleted: (dynamic resultData) {
                  setState(() {
                    _error = null;
                    _message =
                        "Registration succesffull.\n Check your e-mail for verification";
                  });
                },
                onError: (OperationException? error) {
                  setState(() {
                    _message = null;
                    _error = error!.graphqlErrors[0].message.split(":")[1];
                  });
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return Positioned(
                  child: GreenButton(
                      onPressed: () {
                        _formKey.currentState?.save();
                        runMutation({"payload": request.toJson()});
                      },
                      text: "Sign Up"),
                  bottom: 20,
                );
              },
            ),
          ],
          alignment: Alignment.center,
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
