import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const Color green = Color.fromARGB(255, 31, 204, 120);
const Color grey = Color.fromRGBO(159, 165, 192, 1);
const Color errorRed = Color.fromARGB(255, 235, 121, 121);
const Color inputBorder = Color.fromARGB(255, 159, 165, 192);
const Color darkBlue = Color.fromARGB(255, 62, 84, 129);
const String apiLink =
    "http://zavrsnirad-env.eba-dcaqggvc.us-east-1.elasticbeanstalk.com/graphql";
final HttpLink api = HttpLink(
    "http://zavrsnirad-env.eba-dcaqggvc.us-east-1.elasticbeanstalk.com/graphql");
