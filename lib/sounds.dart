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

  Widget playAudioWidget(String trackName, fileName, imgPath) {    
    return 
    SizedBox(
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        semanticContainer: true, // this and the one below are to ensure card has rounded corners and not sharp edges due
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: <Widget>[
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                imgPath,
                height: 400,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              Center(child: Text(trackName)),
              IconButton(
                  icon: updatePlayerIcon(isPlaying, currentTrackName, fileName),
                  iconSize: 40,
                  tooltip: "Toggle audio for this track",
                  onPressed: ()=> toggleAudio(fileName),
                ),
              ],
            ),
          ] 
        ),
      ),
    );
  }

  Widget buildAllAudioWidgets(){
    var audioFileData = [
      {
        "displayName": "Rain and white noise",
        "fileName": "White-noise-rain-sound.mp3",
        "imgPath": "assets/rain-flowers.jpg"
      },
      {
        "displayName": "Rain inside house",
        "fileName": "rain-inside-house.mp3",
        "imgPath": "assets/rain-umbrella.jpg"
      },
    ];

    return ListView.builder(
      itemCount: audioFileData.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index){
        var displayName = audioFileData[index]["displayName"];
        var fileName = audioFileData[index]["fileName"];
        var imgPath = audioFileData[index]["imgPath"];
        return  playAudioWidget(displayName, fileName, imgPath);
      },
    );
  }

  Widget imageFadeTest(){
    return 
    Flexible(
      child: SizedBox(
        height: 150,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: <Widget>[
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/rain-flowers.jpg',
                  height: 400,
                  fit: BoxFit.fill,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Center(child: Text("SOME TEXT BITCH")),
                IconButton(icon: Icon(Icons.pause), tooltip: "ay mate", onPressed: (){print("hello");},),            
                ],
              ),
            ] 
          ),
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
              // playAudioWidget('Rain and white noise', 'White-noise-rain-sound.mp3'),
              // playAudioWidget('Rain inside house', 'rain-inside-house.mp3'),
              buildAllAudioWidgets(),
              RaisedButton(
                onPressed: () =>
                    _sendDataBack(context, isPlaying, playerLoopController,),
                child: Text('Back'),
              ),
              //imageFadeTest(),
            ],
          ),
        ),
      ),
    );
  }
}
