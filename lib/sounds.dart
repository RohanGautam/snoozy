import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Sounds extends StatefulWidget {
  final bool isPlaying;
  final AudioPlayer playerLoopController;

  Sounds(
      {Key key, @required this.isPlaying, @required this.playerLoopController})
      : super(key: key);
  @override
  _SoundsState createState() => _SoundsState();
}

class _SoundsState extends State<Sounds> {
  String playerText = "play";
  bool isPlaying = false;
  AudioPlayer playerLoopController;
  static AudioCache player = AudioCache();

  @override
  void initState() {
    // print("_____________YooT_ ${widget.isPlaying}");
    setState(() {
      isPlaying = widget.isPlaying;
      updatePlayerText(isPlaying);
      playerLoopController = widget.playerLoopController;
    });
  }

  _sendDataBack(
      BuildContext context, bool isPlaying, AudioPlayer playerLoopController) {
    var sendThisData = [isPlaying, playerLoopController];
    Navigator.pop(context, sendThisData);
  }

  updatePlayerText(bool isPlaying) {
    setState(() {
      playerText = isPlaying ? "pause" : "play";
    });
  }

  toggleAudio(String fileName) {
    return () async {
      AudioPlayer currentplayer;
      if (isPlaying == false) {
        currentplayer = await player.loop(fileName);
        setState(() {
          isPlaying = true;
          updatePlayerText(isPlaying);
          playerLoopController = currentplayer;
        });
      } else {
        await playerLoopController.pause();
        setState(() {
          isPlaying = false;
          updatePlayerText(isPlaying);
        });
      }
    };
  }

  Widget playAudioWidget(String trackName, fileName) {
    return 
    Card(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Text('Play $trackName'),
            ButtonTheme(
              minWidth: 48.0,
              child: RaisedButton(
                child: Text(playerText),
                onPressed: toggleAudio(fileName),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Second Route"),
      // ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("hello"),
              playAudioWidget(
                  'Rain and white noise', 'White-noise-rain-sound.mp3'),
              RaisedButton(
                onPressed: () =>
                    _sendDataBack(context, isPlaying, playerLoopController),
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
