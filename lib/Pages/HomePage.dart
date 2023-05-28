import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify2/main.dart';
import 'package:http/http.dart' as http;
import 'package:spotify2/models/User.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? token;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(user == null ? "Placeholder" : user!.display_name)),
      body: Center(child: Container()),
    );
  }

  Future<void> init() async {
    await getAccessToken();
    await getUser();
    await getRecommendations();
    //get recomended songs
    setState(() {});
  }

  Future<void> getAccessToken() async {
    try {
      token = await SpotifySdk.getAccessToken(
          clientId: clientId,
          redirectUrl: redirectUrl,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public, user-read-currently-playing');
      print("dobijen token: $token");
    } on PlatformException catch (e) {
      print("Error: ${e.code} ${e.message}");
    } on MissingPluginException {
      print("Not implemented exception");
    }
  }

  Future<void> getUser() async {
    var response = await http.get(Uri.https("api.spotify.com", "v1/me"),
        headers: {"Authorization": "Bearer $token"});

    user = User.fromJason(jsonDecode(response.body));
  }

  Future<void> getRecommendations() async {
    var response = await http.get(
        Uri.https("api.spotify.com", "v1/recommendations", {
          "limit": "10",
          "market": "ES",
          "seed_artists": "4NHQUGzhtTLFvgF5SZesLK",
          "seed_genres": "classical,country",
          "seed_tracks": "0c6xIDDpzE81m2q797ordA"
        }),
        headers: {"Authorization": "Bearer $token"});
    print(response.body);
  }
}
