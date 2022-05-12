import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavrsni_rad/screens/approoval_screen.dart';
import 'package:zavrsni_rad/screens/favorites_screen.dart';
import 'package:zavrsni_rad/screens/login_screen.dart';
import 'package:zavrsni_rad/screens/users_screen.dart';
import 'package:zavrsni_rad/utilities/shared_preferences_helper.dart';
import '../models/bloc_providers/cover_picture_provider.dart';
import '../models/bloc_providers/ingredients_provider.dart';
import '../models/bloc_providers/recipe_images_provider.dart';
import '../models/bloc_providers/steps_provider.dart';
import '../models/bloc_providers/video_provider.dart';
import '../screens/new_recipe_screen.dart';
import '../screens/recipes_screen.dart';
import '../utilities/global_variables.dart' as globals;
import '../models/constants/constants.dart' as constants;
import '../models/constants/shared_preferences_keys.dart' as keys;

class MenuWidget extends StatelessWidget {
  final int selected;

  const MenuWidget({Key? key, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (globals.loggedInUser == null) {
      return Row(
        children: [
          _MenuItem(
            icon: Icon(
              Icons.home,
              color: selected == 0 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Home",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecipesScreen(
                    selcted: 0,
                  ),
                ),
              );
            },
          ),
          _MenuItem(
            icon: Icon(
              Icons.login,
              color: selected == 1 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Login",
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }
    if (globals.loggedInUser!.role == "USER") {
      return Row(
        children: [
          _MenuItem(
            icon: Icon(
              Icons.home,
              color: selected == 0 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Home",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecipesScreen(
                    selcted: 0,
                  ),
                ),
              );
            },
          ),
          _MenuItem(
            icon: Icon(
              Icons.edit,
              color: selected == 1 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Upload",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<BlocIngredients>(
                        create: (_) => BlocIngredients(),
                      ),
                      BlocProvider<BlocSteps>(
                        create: (_) => BlocSteps(),
                      ),
                      BlocProvider<BlocImages>(
                        create: (_) => BlocImages(),
                      ),
                      BlocProvider<BlocVideo>(
                        create: (_) => BlocVideo(),
                      ),
                      BlocProvider<BlocCoverPicture>(
                        create: (_) => BlocCoverPicture(),
                      ),
                    ],
                    child: const NewRecipeScreen(),
                  ),
                ),
              );
            },
          ),
          _MenuItem(
            icon: Icon(
              Icons.favorite,
              color: selected == 2 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Favorites",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(
                    selected: 2,
                  ),
                ),
              );
            },
          ),
          _MenuItem(
            icon: Icon(
              Icons.person,
              color: selected == 3 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Profile",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipesScreen(
                    authorId: globals.loggedInUser!.id,
                    selcted: 3,
                  ),
                ),
              );
            },
          ),
          _MenuItem(
            icon: Icon(
              Icons.logout,
              color: selected == 4 ? constants.green : constants.grey,
              size: 40,
            ),
            text: "Logout",
            onTap: () {
              globals.loggedInUser = null;
              globals.token = null;
              SharedPreferencesHelper.removeSharedPreference(keys.user);
              SharedPreferencesHelper.removeSharedPreference(keys.token);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      );
    }
    return Row(
      children: [
        _MenuItem(
          icon: Icon(
            Icons.home,
            color: selected == 0 ? constants.green : constants.grey,
            size: 40,
          ),
          text: "Home",
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const RecipesScreen(
                  selcted: 0,
                ),
              ),
            );
          },
        ),
        _MenuItem(
          icon: Icon(
            Icons.approval,
            color: selected == 1 ? constants.green : constants.grey,
            size: 40,
          ),
          text: "Approvals",
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ApproovalScreen(
                  selected: 1,
                ),
              ),
            );
          },
        ),
        _MenuItem(
          icon: Icon(
            Icons.favorite,
            color: selected == 2 ? constants.green : constants.grey,
            size: 40,
          ),
          text: "Favorites",
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const FavoritesScreen(
                  selected: 2,
                ),
              ),
            );
          },
        ),
        _MenuItem(
          icon: Icon(
            Icons.person,
            color: selected == 3 ? constants.green : constants.grey,
            size: 40,
          ),
          text: "Users",
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const UsersScreen(
                  selected: 3,
                ),
              ),
            );
          },
        ),
        _MenuItem(
          icon: Icon(
            Icons.logout,
            color: selected == 4 ? constants.green : constants.grey,
            size: 40,
          ),
          text: "Logout",
          onTap: () {
            globals.loggedInUser = null;
            globals.token = null;
            SharedPreferencesHelper.removeSharedPreference(keys.user);
            SharedPreferencesHelper.removeSharedPreference(keys.token);
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Icon icon;
  final String text;
  final void Function() onTap;

  const _MenuItem(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          InkWell(
            child: icon,
            onTap: onTap,
          ),
          Text(text)
        ],
      ),
    );
  }
}
