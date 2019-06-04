import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';



class Sounds extends StatefulWidget {
  // Sounds({Key key}) : super(key: key);
  @override
  _SoundsState createState() => _SoundsState();
}

class _SoundsState extends State<Sounds> {
  // static AudioCache player = AudioCache();
  // pick up from here: https://github.com/luanpotter/audioplayers/blob/master/doc/audio_cache.md


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Text("hello there"),
      ),
    );
    
  }
}