import 'package:flutter/material.dart';
import 'package:zavrsni_rad/widgets/green_button_widget.dart';
import 'package:zavrsni_rad/widgets/input_field_widget.dart';
import '../models/constants/constants.dart' as constants;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String username;
    String password;
    return Scaffold(
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
                        onSaved: (newValue) => username = newValue!,
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
                GreenButton(onPressed: () {}, text: "Login"),
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
    );
  }
}
