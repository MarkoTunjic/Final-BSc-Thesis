import 'package:flutter/material.dart';
import 'package:zavrsni_rad/screens/login_screen.dart';
import 'package:zavrsni_rad/utilities/shared_preferences_helper.dart';
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
            onTap: () {},
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
          Row(
            children: [
              _MenuItem(
                icon: Icon(
                  Icons.home,
                  color: selected == 0 ? constants.green : constants.grey,
                  size: 40,
                ),
                text: "Home",
                onTap: () {},
              ),
              _MenuItem(
                icon: Icon(
                  Icons.edit,
                  color: selected == 1 ? constants.green : constants.grey,
                  size: 40,
                ),
                text: "Upload",
                onTap: () {},
              ),
            ],
          ),
          Row(
            children: [
              _MenuItem(
                icon: Icon(
                  Icons.person,
                  color: selected == 2 ? constants.green : constants.grey,
                  size: 40,
                ),
                text: "Profile",
                onTap: () {},
              ),
              _MenuItem(
                icon: Icon(
                  Icons.logout,
                  color: selected == 3 ? constants.green : constants.grey,
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
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }
    return Row(
      children: [
        Row(
          children: [
            _MenuItem(
              icon: Icon(
                Icons.home,
                color: selected == 0 ? constants.green : constants.grey,
                size: 40,
              ),
              text: "Home",
              onTap: () {},
            ),
            _MenuItem(
              icon: Icon(
                Icons.approval,
                color: selected == 1 ? constants.green : constants.grey,
                size: 40,
              ),
              text: "Approvals",
              onTap: () {},
            ),
          ],
        ),
        Row(
          children: [
            _MenuItem(
              icon: Icon(
                Icons.person,
                color: selected == 2 ? constants.green : constants.grey,
                size: 40,
              ),
              text: "Users",
              onTap: () {},
            ),
            _MenuItem(
              icon: Icon(
                Icons.logout,
                color: selected == 3 ? constants.green : constants.grey,
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
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
