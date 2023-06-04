import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotify2/AppState.dart';
import 'package:spotify2/Pages/SearchPage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify2/main.dart';
import 'package:http/http.dart' as http;
import 'package:spotify2/models/User.dart';
import 'dart:convert';
import 'package:spotify2/models/Track.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var appState = context.read<AppState>();

    init(appState);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var user = appState.user;
    var tracks = appState.tracks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user == null ? "Placeholder" : user!.display_name,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          StreamBuilder(
              stream: SpotifySdk.subscribePlayerState(),
              builder: (context, snapshot) {
                bool paused = false;
                if (snapshot.data != null) {
                  paused = snapshot.data!.isPaused;
                }

                return Container(
                  color: Colors.grey,
                  height: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (paused) {
                            SpotifySdk.resume();
                          } else {
                            SpotifySdk.pause();
                          }
                        },
                        icon: Icon(
                          paused ? Icons.play_arrow : Icons.pause,
                        ),
                        iconSize: 40,
                      )
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  Future<void> init(AppState appState) async {
    await appState.getAccessToken();
    await appState.getUser();
  }
}
