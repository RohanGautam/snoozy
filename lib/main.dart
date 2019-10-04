import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

//TODO add animations to the dog on click, or something to show it's clickable
//TODO make it intuitive what the bottom number selector does.
// TODO: make selector count BACK! not front 

void main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);// making it potrait-only
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(title: 'snoozy'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime timeShown = DateTime.now();
  var prefs;
  Timer timer;
  var currentHourInPicker;
  var currentMinInPicker;
  bool displayCurrentTime = true;

  @override
  void initState() {
    timeShown = DateTime.now();
    // keep updating time
    timer = Timer.periodic(Duration(milliseconds: 50), (Timer t) => _refreshTime());
    currentHourInPicker = timeShown.hour;
    currentMinInPicker = timeShown.minute;

  }

  void _refreshTime() {
    if(displayCurrentTime){
      setState(() {
        timeShown = DateTime.now();
      });
    }
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
    String currentTimeStr = DateFormat('kk:mm').format(timeShown);
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
    String timeStatus = displayCurrentTime? "now($currentTimeStr)" : "at $currentTimeStr";
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
                    "If you sleep $timeStatus, wake up at",
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

    return GestureDetector(
      onTap: (){
        setState(() {
         timeShown = DateTime.now();
         displayCurrentTime= true; 
        });
      },
      child: Transform.scale(scale: 0.50,child: Image.asset(imgPath),),
      );
  }
  
  Widget timePicker(){
    Widget hourPicker=  NumberPicker.integer(
      initialValue: currentHourInPicker,
      minValue: 0,
      maxValue: 23,
      zeroPad: true,
      infiniteLoop: true,
      onChanged: (val){
        var _hour = val<10 ?"0$val" : "$val" ;
        var _min = timeShown.minute<10 ?"0${timeShown.minute}" : "${timeShown.minute}";
        var newTimeToShow = DateTime.parse("2012-02-27 $_hour:$_min:00"); // only care about hour and minutes
        setState(() {
         currentHourInPicker = val;
         timeShown = newTimeToShow;
         displayCurrentTime = false;
        });
      });
    Widget minutePicker=  NumberPicker.integer(
      initialValue: currentMinInPicker,
      minValue: 0,
      maxValue: 59,
      zeroPad: true,
      infiniteLoop: true,
      onChanged: (val){
        var _hour = timeShown.hour<10 ?"0${timeShown.hour}" : "${timeShown.hour}";
        var _min = val<10 ?"0$val" : "$val" ;
        var newTimeToShow = DateTime.parse("2012-02-27 $_hour:$_min:00"); // only care about hour and minutes
        setState(() {
          currentMinInPicker = val;  
          timeShown = newTimeToShow;
          displayCurrentTime = false;
        });
      });
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            hourPicker,
            minutePicker
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          dogImage("assets/sleepyDog.png"),
          sleepCard(timeShown),
          timePicker()
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
