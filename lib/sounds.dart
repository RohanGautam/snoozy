import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';



class Sounds extends StatefulWidget {
  Sounds({Key key}) : super(key: key);
  @override
  _SoundsState createState() => _SoundsState();
}

class _SoundsState extends State<Sounds> {
  String playerText="play";
  bool isPlaying = false;
  AudioPlayer playerLoopController;
  static AudioCache player = AudioCache();


  updatePlayerText(bool isPlaying){
    setState(() {
     playerText = isPlaying ? "pause" : "play"; 
    });
  }

  toggleAudio(String fileName) {
    return () async {
      AudioPlayer currentplayer;
      if (isPlaying==false) {
        currentplayer = await player.loop(fileName);
        setState(() {
          isPlaying = true;
          updatePlayerText(isPlaying);
          playerLoopController = currentplayer;
        });
      }
      else{
        await playerLoopController.pause(); 
        setState(() {
          isPlaying = false;
          updatePlayerText(isPlaying);
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
