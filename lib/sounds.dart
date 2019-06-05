import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';



class Sounds extends StatefulWidget {
  Sounds({Key key}) : super(key: key);
  @override
  _SoundsState createState() => _SoundsState();
}

class _SoundsState extends State<Sounds> {
  String playerText="play";
  AudioPlayer playerLoopController;
  static AudioCache player = AudioCache();
  toggleAudio(String fileName) {
    return () async {
      AudioPlayer currentplayer;
      if (playerText.toLowerCase() == "play") {
        currentplayer = await player.loop(fileName);
        setState(() {
          playerText="pause";
          playerLoopController = currentplayer;
        });
      }
      else{
        await playerLoopController.pause(); 
        setState(() {
          playerText="play";
        });
      }
    };
  }

  Widget playAudioWidget() {
    return Column(
      children: <Widget>[
        Text('Play rain+white noise sounds:'),
        ButtonTheme(
          minWidth: 48.0,
          child: RaisedButton(
            child: Text(playerText),
            onPressed: toggleAudio('White-noise-rain-sound.mp3'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Column(
        children: <Widget>[
          Text("hello"),
          playAudioWidget(),
        ],
      ),
    );
  }

}
