import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify2/Pages/HomePage.dart';
import 'package:spotify2/Pages/LoginPage.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return LoginPage();
          }
          if (data.connected == false) {
            return LoginPage();
          }

          return HomePage();
        },
      ),
    );
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString());
    } on PlatformException catch (e) {
    } on MissingPluginException {}
  }
}
