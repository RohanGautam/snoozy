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

  updatePlayerIcon(bool isPlaying, String currentTrackName, String fileName) {
    print("$currentTrackName and $fileName");
    // return isPlaying ? "pause": "play";
    var play=Icon(Icons.play_arrow); //"play"
    var pause= Icon(Icons.pause); //"pause"
    if(currentTrackName==null || !isPlaying){
        return play;
      }
    if(isPlaying){      
      if (currentTrackName==fileName){// look at current tracknme
        return pause;
      }
      else{
        return play;
      }
    }
  }

  toggleAudio(String fileName) async {

    //print("current track is $currentTrackName");
    AudioPlayer currentplayer;

    _playFile(fileName) async{
      currentplayer = await player.loop(fileName);
      setState(() {
        isPlaying = true;
        playerLoopController = currentplayer;
        currentTrackName = fileName;
      });
    }

    if (isPlaying == false) {
      _playFile(fileName);
    } 
    else {
      //same button pressed, then pause that
      await playerLoopController.pause();
      setState(() {
        isPlaying = false;
      });
      // ie, a diff button was pressed, pause current one, then play that
      if(currentTrackName!=fileName){
        _playFile(fileName);
      }

    }
    
  }

  Widget playAudioWidget(String trackName, fileName) {    
    return 
    Card(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('$trackName'),
            IconButton(
              icon: updatePlayerIcon(isPlaying, currentTrackName, fileName),
              iconSize: 40,
              tooltip: "Toggle audio for this track",
              onPressed: ()=> toggleAudio(fileName),
            ),
            // ButtonTheme(
            //   minWidth: 48.0,
            //   child: RaisedButton(
            //     //currenttrackname is initially null
            //     child: Text(updatePlayerText(isPlaying, currentTrackName, fileName)),
            //     onPressed: () => toggleAudio(fileName),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildAllAudioWidgets(){
    var audioFileData = [
      {
        "displayName": "Rain and white noise",
        "fileName": "White-noise-rain-sound.mp3",
      },
      {
        "displayName": "Rain inside house",
        "fileName": "rain-inside-house.mp3",
      },
    ];

    return ListView.builder(
      itemCount: audioFileData.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index){
        var displayName = audioFileData[index]["displayName"];
        var fileName = audioFileData[index]["fileName"];
        return  playAudioWidget(displayName, fileName);
      },
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
              // playAudioWidget('Rain and white noise', 'White-noise-rain-sound.mp3'),
              // playAudioWidget('Rain inside house', 'rain-inside-house.mp3'),
              buildAllAudioWidgets(),
              RaisedButton(
                onPressed: () =>
                    _sendDataBack(context, isPlaying, playerLoopController,),
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
