import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavrsni_rad/models/bloc_providers/cover_picture_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/ingredients_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/recipe_images_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/steps_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/video_provider.dart';
import 'package:zavrsni_rad/models/ingredient.dart';
import 'package:zavrsni_rad/models/new_recipe.dart';
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
import '../models/recipe_step.dart';
import '../widgets/images_input_widget.dart';
import '../widgets/steps_input_widget.dart';

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
  final ImagePicker _picker = ImagePicker();

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
        body: Form(
          key: NewRecipeScreen.formKey,
          child: ListView(
            padding:
                const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
            children: [
              Container(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                          style: TextStyle(color: constants.grey, fontSize: 15),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  BlocBuilder<BlocIngredients, List<Ingredient>>(
                    builder: ((context, state) {
                      newRecipe.ingredients = state;
                      return FormField(
                        builder: (_) => IngredientsWidget(ingredients: state),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                            style:
                                TextStyle(color: constants.grey, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
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
                    newRecipe.videoExtension = "." + state.path.split(".").last;
                  }
                  return BlocVideoWidget(video: state);
                }),
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(mutations.addRecipe),
                  onCompleted: (dynamic resultData) {
                    if (resultData == null) return;
                    Navigator.pop(context);
                  },
                  onError: (OperationException? e) {
                    for (GraphQLError error in e!.graphqlErrors) {
                      print(error.message);
                    }
                  },
                ),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GreenButton(
                      onPressed: () {
                        NewRecipeScreen.formKey.currentState?.save();
                        runMutation({"payload": newRecipe.toJson()});
                      },
                      text: "Submit",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
