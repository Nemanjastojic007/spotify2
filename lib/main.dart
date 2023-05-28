import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify2/spotifyExample.dart' as Example;

import 'Pages/MainPage.dart';

String clientId = "7604db9d870b4c6eb2a3636e05e8c0a8";
String redirectUrl =
    "https://nemanjastojic007.github.io/redirect/redirect.html";
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(MainPage());
}
