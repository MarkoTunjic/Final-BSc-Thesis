import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavrsni_rad/screens/login_screen.dart';
import 'package:zavrsni_rad/widgets/circular_image_with_white_border.dart';
import '../utilities/global_variables.dart' as globals;
import '../models/constants/shared_preferences_keys.dart' as keys;

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  Future<SharedPreferences> _getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SharedPreferences? prefs;
    _getSharedPreferences().then(((value) => prefs = value));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height / 2,
            child: Stack(
              children: [
                Align(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image8.png",
                    radius: width / 5,
                  ),
                  alignment: Alignment.center,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image1.png",
                    radius: width / 9,
                  ),
                  left: 30,
                  top: 20,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image2.png",
                    radius: width / 7,
                  ),
                  top: 10,
                  right: width / 7,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image3.png",
                    radius: width / 10,
                  ),
                  right: -20,
                  top: height / 4 - width / 10 - 20,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image4.png",
                    radius: width / 11,
                  ),
                  right: width / 11,
                  top: height / 4 + width / 11,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image5.png",
                    radius: width / 9,
                  ),
                  right: width / 2 - width / 9 - 20,
                  top: height / 2 - width / 9 * 2 - 10,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image6.png",
                    radius: width / 11,
                  ),
                  right: width / 2 + width / 11 * 2,
                  top: height / 2 - width / 9 * 2 - 10,
                ),
                Positioned(
                  child: CircularImageWithWhiteBorder(
                    imageLocation: "assets/image6.png",
                    radius: width / 7,
                  ),
                  left: -20,
                  top: height / 4 - width / 7,
                ),
              ],
            ),
          ),
          Column(
            children: const [
              Text(
                "Start cooking\n",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                "Let's join our community\nto cook better food!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 159, 165, 192)),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async => {
              prefs!.setBool(keys.startedKey, true),
              globals.started = true,
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              ),
            },
            child: Container(
              child: const Text(
                "Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              width: width / 3 * 2,
              padding: const EdgeInsets.all(15),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 31, 204, 120),
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}
