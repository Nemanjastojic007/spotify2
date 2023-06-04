import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:spotify2/AppState.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String value = "";
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var tracks = appState.tracks;
    return Scaffold(
      appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextField(
            decoration: InputDecoration(border: null, hintText: "Search"),
            onSubmitted: (value) {
              context.read<AppState>().getTrack(value);
            },
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tracks[index].name),
                  subtitle: Text(tracks[index].id),
                  onTap: () {
                    SpotifySdk.play(
                        spotifyUri: "spotify:track:${tracks[index].id}");
                  },
                );
              },
              itemCount: tracks.length,
            ),
          ),
          // StreamBuilder(
          //     stream: SpotifySdk.subscribePlayerState(),
          //     builder: (context, snapshot) {
          //       bool paused = false;
          //       if (snapshot.data != null) {
          //         paused = snapshot.data!.isPaused;
          //       }
          //       print(snapshot.hasError);
          //       return Container(
          //         color: Colors.grey,
          //         height: 100,
          //         child: Row(
          //           mainAxisSize: MainAxisSize.max,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             IconButton(
          //               onPressed: () {
          //                 if (paused) {
          //                   SpotifySdk.resume();
          //                 } else {
          //                   SpotifySdk.pause();
          //                 }
          //               },
          //               icon: Icon(
          //                 paused ? Icons.play_arrow : Icons.pause,
          //               ),
          //               iconSize: 40,
          //             )
          //           ],
          //         ),
          //       );
          //     })
        ],
      ),
    );
  }
}
