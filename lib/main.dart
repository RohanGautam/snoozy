import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);// making it potrait-only
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
            primarySwatch: Colors.indigo,
            brightness: brightness,
          ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: MyHomePage(title: 'snoozy'),
          debugShowCheckedModeBanner: false,
        );
      });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now = DateTime.now();
  var _switchValue = false;
  var prefs;
  Timer timer;

  @override
  void initState() {
    //executed only once
    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    SharedPreferences.getInstance().then((_prefs) {
      setState(() {
        prefs = _prefs;
        // make the initial state of the switch same as previously stored state when the app reloads
        _switchValue = prefs.getBool('switchValue') ??
            false; // ?? means if null, make it false
      });
    });

    // keep updating time
    timer = Timer.periodic(Duration(milliseconds: 50), (Timer t) => _refreshTime());

  }

  void _refreshTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  void changeTheme(bool s) {
    setState(() {
      //switch passes current state of switch, but doesnt change it in UI. to do that, you have to change it yourself.
      _switchValue = s;
    });
    prefs.setBool('switchValue', s);
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Widget themeToggler() {
    return 
    Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              Transform.scale(     
                scale: 1.5,       
                child: Switch(
                  value: _switchValue, 
                  onChanged: changeTheme,
                ),
              ),
              Text("DarkMode")
            ],
          ),
        ],
      ),
    );
  }

  List<DateTime> _sleepTimeLogic(DateTime now) {
    // to calculate sleep timings
    List<DateTime> times = [];
    int timeToFallAsleep = 14, _hours = 0, _mins = 0;
    // some logic to keep adding 1 and a half hours(duration of 1 full sleep cycle), and 14 minutes(avg time taken to fall asleep)
    for (int i = 1; i < 7; i++) {
      _hours = i % 2 == 0 ? _hours + 2 : _hours + 1;
      _mins = i % 2 == 0 ? 0 : 30;
      times.add(now
          .add(new Duration(hours: _hours, minutes: _mins + timeToFallAsleep)));
      // print("$_hours,  $_mins");
    }

    return times;
  }

  Widget sleepCard(DateTime time) {
    String currentTimeStr = DateFormat('kk:mm').format(now);
    List<DateTime> timesToWake = _sleepTimeLogic(time);

    Widget individualTimeWidget(var time, Color c){
      return Text("${DateFormat('kk:mm').format(time)}", style: TextStyle(fontSize: 40, color: c,),);
    }

    Widget _timeStringsWidget(){
      var w1 =individualTimeWidget(timesToWake[0], Color.fromRGBO(168, 39, 254, 1));
      var w2 =individualTimeWidget(timesToWake[1], Color.fromRGBO(154, 39, 254, 1));
      var w3 =individualTimeWidget(timesToWake[2], Color.fromRGBO(150, 105, 254, 1));
      var w4 =individualTimeWidget(timesToWake[3], Color.fromRGBO(140, 140, 255, 1));
      var w5 =individualTimeWidget(timesToWake[4], Color.fromRGBO(187, 187, 255, 1));
      var w6 =individualTimeWidget(timesToWake[5], Color.fromRGBO(143, 254, 221, 1));

      var orWidget = Text("or", style: TextStyle(fontStyle: FontStyle.italic));
      return Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[w1, orWidget, w2]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[w3, orWidget, w4]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[w5, orWidget, w6])
        ],
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), 
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    "If you sleep now($currentTimeStr), wake up at",
                  ),
                  _timeStringsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dogImage(String imgPath){
    return Transform.scale(scale: 0.60,child: Image.asset(imgPath),);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          themeToggler(),
          dogImage("assets/sleepyDog.png"),
          sleepCard(now),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
