import 'package:flutter/material.dart';

class InfoButton extends StatefulWidget {
  @override
  _InfoButtonState createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  var isPressed = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: !isPressed ? Icon(Icons.info) : Icon(Icons.close),
      onPressed: !isPressed ? () => showInfo(context) : () => close(context),
    );
  }

  close(context) {
    Navigator.pop(context);
    setState(() {
      isPressed = false;
    });
  }

  showInfo(context) {
    setState(() {
      isPressed = true;
    });
    var bottomSheetController = showBottomSheet(
        context: context,
        builder: (context) {
          double deviceHeight = MediaQuery.of(context).size.height;
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            height: deviceHeight / 3,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Snoozy v1.0',
                    style: TextStyle(
                        fontSize: 25, color: Color.fromRGBO(143, 254, 221, 1)),
                  ),
                  Text('What is snoozy?',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      'Snoozy helps you calculate when to get up if you go to sleep now (click the dog!), or when to go to bed if you want to wake up at a certain time(use the time slider wheels!)'),
                  Text('How does it work?',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                      'Snoozy suggests its timings based on human sleep cycles (1.5 hrs each) and time taken to fall asleep(14 mins on average).'),
                  Text(
                      'Waking up in the middle of a sleep cycle makes you feel groggy and not rested. No more with snoozy!'),
                ],
              ),
            ),
          );
        });
    bottomSheetController.closed.then((value) {
      setState(() {
        isPressed = false;
      });
    });
  }
}
