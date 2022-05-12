import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavrsni_rad/models/bloc_providers/cover_picture_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/ingredients_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/recipe_images_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/steps_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/video_provider.dart';
import 'package:zavrsni_rad/models/ingredient.dart';
import 'package:zavrsni_rad/models/new_recipe.dart';
import 'package:zavrsni_rad/screens/recipes_screen.dart';
import 'package:zavrsni_rad/widgets/bloc_cover_picture_widget.dart';
import 'package:zavrsni_rad/widgets/bloc_video_widget.dart';
import 'package:zavrsni_rad/widgets/green_button_widget.dart';
import 'package:zavrsni_rad/widgets/ingredients_input_widget.dart';
import 'package:zavrsni_rad/widgets/input_field_widget.dart';
import 'package:zavrsni_rad/widgets/multiline_input_field_widget.dart';
import 'package:zavrsni_rad/widgets/picture_picker_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../models/constants/graphql_mutations.dart' as mutations;
import '../utilities/global_variables.dart' as globals;
import '../models/constants/shared_preferences_keys.dart' as keys;
import '../models/recipe_step.dart';
import '../utilities/shared_preferences_helper.dart';
import '../widgets/images_input_widget.dart';
import '../widgets/steps_input_widget.dart';
import 'login_screen.dart';

class NewRecipeScreen extends StatefulWidget {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  const NewRecipeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewRecipeState();
  }
}

class _NewRecipeState extends State<NewRecipeScreen> {
  double _currentSliderValue = 30;
  NewRecipe newRecipe =
      NewRecipe(cookingDuration: 30, userId: globals.loggedInUser!.id);
  String? _error;
  final ImagePicker _picker = ImagePicker();
  bool _showProgressIndicator = false;
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
            Form(
              key: NewRecipeScreen.formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(
                    top: 40, bottom: 15, left: 15, right: 15),
                children: [
                  InkWell(
                    child: Container(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: constants.errorRed,
                          fontSize: 20,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  BlocBuilder<BlocCoverPicture, File?>(
                    builder: ((context, state) {
                      if (state != null) {
                        newRecipe.coverPicture =
                            base64Encode(state.readAsBytesSync());
                      }
                      return FormField(
                        builder: (_) => BlocCoverPictureWidget(image: state),
                      );
                    }),
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Recipe name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      InputFieldWidget(
                        hintText: "Enter recipe name",
                        onChanged: (value) => newRecipe.recipeName = value,
                        obscure: false,
                        icon: null,
                        width: MediaQuery.of(context).size.width - 20,
                        initialValue: newRecipe.recipeName,
                        type: TextInputType.text,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      MultilineInputFieldWidget(
                        hintText: "Tell a little about your recipe\n\n",
                        onChanged: (value) => newRecipe.description = value,
                        width: MediaQuery.of(context).size.width - 20,
                        initialValue: newRecipe.description,
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: const [
                            Text(
                              "Cooking duration",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              " (in minutes)",
                              style: TextStyle(
                                  color: constants.grey, fontSize: 15),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ),
                      Row(
                        children: ["<0", "30", "60", "90", "120>"]
                            .map((e) => Text(
                                  e,
                                  style: const TextStyle(
                                      color: constants.green,
                                      fontWeight: FontWeight.bold),
                                ))
                            .toList(),
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      Slider(
                        value: _currentSliderValue,
                        max: 120,
                        divisions: 4,
                        min: 0,
                        onChanged: (double value) {
                          newRecipe.cookingDuration = value.toInt();
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Ingredients",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      BlocBuilder<BlocIngredients, List<Ingredient>>(
                        builder: ((context, state) {
                          newRecipe.ingredients = state;
                          return FormField(
                            builder: (_) =>
                                IngredientsWidget(ingredients: state),
                          );
                        }),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Steps",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      BlocBuilder<BlocSteps, List<RecipeStep>>(
                        builder: ((context, state) {
                          newRecipe.steps = state;
                          return FormField(
                            builder: (_) => StepsWidget(steps: state),
                          );
                        }),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Images and videos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      PicturePickerWidget(
                        text: Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                "Add image",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Text(
                                "(Up To 12MB)",
                                style: TextStyle(
                                    color: constants.grey, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            File file = File(image.path);
                            BlocProvider.of<BlocImages>(context)
                                .add(AddImage(image: file));
                            return;
                          }
                        },
                        iconSize: MediaQuery.of(context).size.width / 10,
                        radius: const Radius.circular(20),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  BlocBuilder<BlocImages, List<File>>(
                    builder: ((context, state) {
                      newRecipe.images = state
                          .map((e) => base64Encode(e.readAsBytesSync()))
                          .toList();
                      return ImagesInputWidget(images: state);
                    }),
                  ),
                  BlocBuilder<BlocVideo, File?>(
                    builder: ((context, state) {
                      if (state != null) {
                        newRecipe.video = base64Encode(state.readAsBytesSync());
                        newRecipe.videoExtension =
                            "." + state.path.split(".").last;
                      }
                      return BlocVideoWidget(video: state);
                    }),
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
                  Mutation(
                    options: MutationOptions(
                      document: gql(mutations.addRecipe),
                      onCompleted: (dynamic resultData) {
                        _showProgressIndicator = false;
                        if (resultData == null) return;
                        _error = null;
                        Fluttertoast.showToast(
                          msg: "Successfully added new recipe", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.CENTER, // location// duration
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecipesScreen(selcted: 0),
                          ),
                        );
                      },
                      onError: (OperationException? error) {
                        if (error == null) return;
                        if (error.graphqlErrors[0].message
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
                          return;
                        }
                        setState(() {
                          _error = error.graphqlErrors[0].message.split(":")[1];
                        });
                      },
                    ),
                    builder: (RunMutation runMutation, QueryResult? result) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GreenButton(
                          onPressed: () {
                            NewRecipeScreen.formKey.currentState?.save();
                            runMutation({"payload": newRecipe.toJson()});
                            setState(() {
                              _showProgressIndicator = true;
                            });
                          },
                          text: "Submit",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
