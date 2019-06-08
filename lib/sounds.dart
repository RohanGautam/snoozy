import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Sounds extends StatefulWidget {
  final bool isPlaying;
  final AudioPlayer playerLoopController;
  final String currentTrackName;

  Sounds(
      {Key key, @required this.isPlaying, @required this.playerLoopController, @required this.currentTrackName})
      : super(key: key);
  @override
  _SoundsState createState() => _SoundsState();
}

class _SoundsState extends State<Sounds> {
  String playerText = "play";
  bool isPlaying = false;
  AudioPlayer playerLoopController;
  static AudioCache player = AudioCache();
  String currentTrackName;

  @override
  void initState() {
    // print("_____________YooT_ ${widget.isPlaying}");
    setState(() {
      isPlaying = widget.isPlaying;
      playerLoopController = widget.playerLoopController;
      currentTrackName = widget.currentTrackName;
    });
  }

  _sendDataBack(BuildContext context, bool isPlaying, AudioPlayer playerLoopController) {
    var sendThisData = [isPlaying, playerLoopController, currentTrackName];
    Navigator.pop(context, sendThisData);
  }

  String updatePlayerText(bool isPlaying, String currentTrackName, String fileName) {
    print("$currentTrackName and $fileName");
    // return isPlaying ? "pause": "play";
    if(currentTrackName==null || !isPlaying){
        return "play";
      }
    if(isPlaying){      
      if (currentTrackName==fileName){// look at current tracknme
        return "pause";
      }
      else{
        return "play";
      }
    }
    return("nothing");
  }

  toggleAudio(String fileName) async {
    setState(() {
     currentTrackName = fileName; 
    });
    print("current track is $currentTrackName");
    AudioPlayer currentplayer;
    if (isPlaying == false) {
      currentplayer = await player.loop(fileName);
      setState(() {
        isPlaying = true;
        playerLoopController = currentplayer;
      });
    } else {
      await playerLoopController.pause();
      setState(() {
        isPlaying = false;
      });
    }
    
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
                //currenttrackname is initially null
                child: Text(updatePlayerText(isPlaying, currentTrackName, fileName)),
                onPressed: () => toggleAudio(fileName),
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
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("hello"),
              playAudioWidget('Rain and white noise', 'White-noise-rain-sound.mp3'),
              playAudioWidget('Rain inside house', 'rain-inside-house.mp3'),
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
