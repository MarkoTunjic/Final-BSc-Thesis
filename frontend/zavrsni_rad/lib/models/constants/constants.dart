import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const Color green = Color.fromARGB(255, 31, 204, 120);
const Color grey = Color.fromRGBO(159, 165, 192, 1);
const Color errorRed = Color.fromARGB(255, 235, 121, 121);
const Color inputBorder = Color.fromARGB(255, 159, 165, 192);
final HttpLink api = HttpLink("http://10.0.2.2:5000/graphql");
