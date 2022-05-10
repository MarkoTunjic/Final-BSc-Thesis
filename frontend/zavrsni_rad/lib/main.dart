import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/screens/get_started_screen.dart';
import 'package:zavrsni_rad/screens/login_screen.dart';
import 'package:zavrsni_rad/screens/recipes_screen.dart';
import 'package:zavrsni_rad/utilities/shared_preferences_helper.dart';
import './utilities/global_variables.dart' as globals;
import '../models/constants/constants.dart' as constants;

Future<void> main() async {
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    SharedPreferencesHelper.readSharedPreferences();
    return FutureBuilder(
      builder: (context, snapshot) {
        Widget firstScreen;
        if (!globals.started) {
          firstScreen = const GetStartedScreen();
        } else if (globals.loggedInUser == null) {
          firstScreen = const LoginScreen();
        } else {
          firstScreen = const RecipesScreen(
            selcted: 0,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: firstScreen,
            theme: ThemeData().copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: constants.green,
                  ),
            ),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: SharedPreferencesHelper.readSharedPreferences(),
    );
  }
}
