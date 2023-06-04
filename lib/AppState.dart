import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify2/models/Track.dart';
import 'package:spotify2/models/User.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class AppState extends ChangeNotifier {
  String? accessToken;
  User? user;
  List<Track> tracks = [];

  Future<void> getAccessToken() async {
    try {
      accessToken = await SpotifySdk.getAccessToken(
          clientId: clientId,
          redirectUrl: redirectUrl,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public, user-read-currently-playing');
      print("dobijen token: $accessToken");
    } on PlatformException catch (e) {
      print("Error: ${e.code} ${e.message}");
    } on MissingPluginException {
      print("Not implemented exception");
    }
    notifyListeners();
  }

  Future<void> getUser() async {
    var response = await http.get(Uri.https("api.spotify.com", "v1/me"),
        headers: {"Authorization": "Bearer $accessToken"});

    user = User.fromJason(jsonDecode(response.body));
    notifyListeners();
  }

  Future<void> getTrack(String value) async {
    var response = await http.get(
        Uri.https("api.spotify.com", "v1/search", {
          "q": value,
          "type": ["track"],
          "market": "ES",
          "limit": "10",
          "offset": "5"
        }),
        headers: {"Authorization": "Bearer $accessToken"});
    dynamic json = jsonDecode(response.body);

    List<dynamic> jsonTracks = json["tracks"]["items"];

    tracks = [];

    // tracks.add(Track.fromJason(json["tracks"]));
    for (int i = 0; i < jsonTracks.length; i++) {
      tracks.add(Track.fromJason(jsonTracks[i]));
    }
    notifyListeners();
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
        headers: {"Authorization": "Bearer $accessToken"});
    print(response.body);
    notifyListeners();
  }
}
