import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:zavrsni_rad/models/bloc_providers/cover_picture_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/ingredients_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/recipe_images_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/steps_provider.dart';
import 'package:zavrsni_rad/models/bloc_providers/video_provider.dart';
import 'package:zavrsni_rad/screens/get_started_screen.dart';
import 'package:zavrsni_rad/screens/login_screen.dart';
import 'package:zavrsni_rad/utilities/shared_preferences_helper.dart';
import './utilities/global_variables.dart' as globals;
import '../models/constants/constants.dart' as constants;
import 'models/bloc_providers/profile_picture_provider.dart';

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
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: globals.started
                ? const LoginScreen()
                : const GetStartedScreen(),
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
