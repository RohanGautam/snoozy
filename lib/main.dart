import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

import 'homePage.dart';

//TODO: if move just one wheel, both hour and min should reflect the wheel values
//TODO make it intuitive what the bottom number selector does.
//TODO: add app icon
// TODO: show time to sleep at with bright colors first
// TODO: add info page
// TODO: grey out times that have already passed while setting time in the wheels

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);// making it potrait-only
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snoozy',
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(title: 'Snoozy'),
      debugShowCheckedModeBanner: false,
    );
  }
}
