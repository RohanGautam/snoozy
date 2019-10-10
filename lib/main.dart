// import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
    List<DateTime> times = [];
    int timeToFallAsleep = 14, _hours = 0, _mins = 0; // time to fall asleep in in mins
    if(displayCurrentTime){
      // to calculate sleep timings forwards
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
    else{
      // to calculate sleep timings forwards
      // some logic to keep adding 1 and a half hours(duration of 1 full sleep cycle), and 14 minutes(avg time taken to fall asleep)
      for (int i = 1; i < 7; i++) {
        _hours = i % 2 == 0 ? _hours + 2 : _hours + 1;
        _mins = i % 2 == 0 ? 0 : 30;
        times.add(now
            .subtract(new Duration(hours: _hours, minutes: _mins + timeToFallAsleep)));
        // print("$_hours,  $_mins");
        }
        return times.reversed.toList(); // to show most recent time first
    }
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
    String timeStatus = displayCurrentTime? "If you sleep now($currentTimeStr), wake up at" : "If you wake up at $currentTimeStr, sleep at";
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
                    timeStatus,
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
      child:SizedBox(height: 200,child: Image.network(imgPath)), //Transform.scale(scale: 0.50,child: Image.network(imgPath, scale: 2,),),
      );
  }

  final FlareControls _controls = FlareControls();
  Widget dogAnimation(String animationPath){
    return  Container(
      height: 280,
      width: 300,
        child: GestureDetector(
          onTap: (){
            _controls.play("press");
            setState(() {
              timeShown = DateTime.now();
              displayCurrentTime= true; 
            });
          },
          child: FlareActor(animationPath,
            // alignment: Alignment.topCenter,
            shouldClip: false,
            fit: BoxFit.contain,
            animation: "idle", // not specified, but giving an unspecified name means no animation will be played initially
            controller: _controls,
          ),
        ),
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
          // dogAnimation("dogAnimation.flr"),
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

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.display1,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
