import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:snoozy_app/sounds.dart';

void main() => runApp(MyApp());

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
            home:MyHomePage(title: 'snoozy'),
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

  Future<bool> saveThemeToggleState() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool("switchValue", _switchValue) ?? false;
  	// return prefs.setBool(_switchValue) ?? false;
  }
  Future<bool> getThemeToggleState() async {
	final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("switchValue") ?? false;
  	// return prefs.setBool(_switchValue) ?? false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() async{
     _switchValue= await getThemeToggleState();
    });

  }

  void _refreshTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  void changeTheme(bool s) {
    setState(() {
      _switchValue =
          s; //switch passes current state of switch, but doesnt cahange it in UI. to do that, you have to change it yourself.
    });

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
    var timeStyle = TextStyle(fontSize: 40);

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
              Text(
                "${DateFormat('kk:mm').format(timesToWake[0])}, ${DateFormat('kk:mm').format(timesToWake[1])}",
                style: timeStyle,
              ),
              Text(
                " ${DateFormat('kk:mm').format(timesToWake[2])}, ${DateFormat('kk:mm').format(timesToWake[3])}",
                style: timeStyle,
              ),
              Text(
                "${DateFormat('kk:mm').format(timesToWake[4])}, ${DateFormat('kk:mm').format(timesToWake[5])}",
                style: timeStyle,
              ),
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

  Widget bottomDock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "soundsNavButton",
          tooltip: "Go to new page",
          child: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) => Sounds()));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
