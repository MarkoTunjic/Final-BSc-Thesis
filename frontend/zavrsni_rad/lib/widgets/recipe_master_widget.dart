import 'package:flutter/material.dart';
import 'package:zavrsni_rad/models/recipe_master.dart';
import '../models/constants/constants.dart' as constants;
import '../utilities/global_variables.dart' as globals;

class RecipeMasterWidget extends StatelessWidget {
  final RecipeMaster recipe;

  const RecipeMasterWidget({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(recipe.user.profilePicture),
              ),
            ),
            Text(
              recipe.user.username,
              style: const TextStyle(color: constants.darkBlue),
            ),
          ],
        ),
        Stack(
          children: [
            ClipRRect(
              child: Image.network(
                recipe.coverPicture,
                fit: BoxFit.cover,
                height: availableWidth / 2 - 10,
                width: availableWidth / 2 - 10,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            globals.loggedInUser != null
                ? Positioned(
                    child: Container(
                      child: IconButton(
                        onPressed: () {},
                        icon: recipe.isLikedByCurrentUser
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border_outlined,
                                color: Colors.white),
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(182, 158, 158, 158),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.all(5),
                    ),
                    right: 0,
                  )
                : Container(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            recipe.recipeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                recipe.averageRating.toStringAsFixed(1),
                style: const TextStyle(color: constants.darkBlue),
              ),
              const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              const Icon(
                Icons.circle,
                size: 10,
                color: constants.grey,
              ),
              Text(
                " >" + recipe.cookingDuration.toString() + "mins",
                style: const TextStyle(color: constants.darkBlue),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
