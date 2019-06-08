import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:snoozy_app/sounds.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);// making it potrait-only
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            home: MyHomePage(title: 'snoozy'),
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
  // **--for the sounds page--**
  bool isPlaying = false;
  AudioPlayer playerLoopController;
  String currentTrackName;
  // **----**

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
  }

  void _refreshTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  void changeTheme(bool s) {
    setState(() {
      //switch passes current state of switch, but doesnt cahange it in UI. to do that, you have to change it yourself.
      _switchValue = s;
    });
    prefs.setBool('switchValue', s);
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Widget themeToggler() {
    return Switch(value: _switchValue, onChanged: changeTheme);
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

    Widget _timeStringsWidget(){
      var w1 =Text("${DateFormat('kk:mm').format(timesToWake[0])}", style: TextStyle(fontSize: 40, color: Color.fromRGBO(168, 39, 254, 1)));
      var w2 =Text("${DateFormat('kk:mm').format(timesToWake[1])}", style: TextStyle(fontSize: 40, color: Color.fromRGBO(154, 39, 254, 1)));
      var w3 =Text("${DateFormat('kk:mm').format(timesToWake[2])}", style: TextStyle(fontSize: 40, color: Color.fromRGBO(150, 105, 254, 1)));
      var w4 =Text("${DateFormat('kk:mm').format(timesToWake[3])}", style: TextStyle(fontSize: 40, color: Color.fromRGBO(140, 140, 255, 1)));
      var w5 =Text("${DateFormat('kk:mm').format(timesToWake[4])}", style: TextStyle(fontSize: 40, color: Color.fromRGBO(187, 187, 255, 1)));
      var w6 =Text("${DateFormat('kk:mm').format(timesToWake[5])}", style: TextStyle(fontSize: 40, color: Color.fromRGBO(143, 254, 221, 1)));

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
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                "If you sleep now($currentTimeStr), wake up at",
              ),
              _timeStringsWidget(),
              // Text(
              //   "${DateFormat('kk:mm').format(timesToWake[0])}, ${DateFormat('kk:mm').format(timesToWake[1])}",
              //   style: TextStyle(fontSize: 40, color: Color.fromRGBO(168, 39, 254, 1)),
              // ),
              // Text(
              //   " ${DateFormat('kk:mm').format(timesToWake[2])}, ${DateFormat('kk:mm').format(timesToWake[3])}",
              //   style: TextStyle(fontSize: 40, color: Color.fromRGBO(140, 140, 255, 1)),
              // ),
              // Text(
              //   "${DateFormat('kk:mm').format(timesToWake[4])}, ${DateFormat('kk:mm').format(timesToWake[5])}",
              //   style: TextStyle(fontSize: 40, color: Color.fromRGBO(143, 254, 221, 1)),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "refreshButton",
                    onPressed: _refreshTime,
                    tooltip: 'Refresh',
                    child: Icon(Icons.refresh),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _soundsPage(BuildContext context, var page) async {
    var dataRecieved = await Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => new Sounds(
                isPlaying: isPlaying,
                playerLoopController: playerLoopController,
                currentTrackName: currentTrackName,)));
    // MaterialPageRoute(
    //     builder: (context) => ));
    setState(() {
      isPlaying = dataRecieved[0];
      playerLoopController = dataRecieved[1];
      currentTrackName = dataRecieved[2];
    });
    // print(isPlaying);
  }

  Widget bottomDock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "soundsNavButton",
          tooltip: "Go to new page",
          child: Icon(Icons.arrow_forward),
          onPressed: () => _soundsPage(context, Sounds), //this is a shorthand if you want to pass a function with parameters
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            themeToggler(),
            sleepCard(now),
            bottomDock(),
          ],
        ),
      ),
    );
  }
}
