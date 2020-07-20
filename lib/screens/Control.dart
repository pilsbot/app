import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/components/ControlModeSwitch.dart';
import 'package:pilsbot/components/EmergencySwitch.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:pilsbot/components/SoundBar.dart';
import 'package:pilsbot/components/Joystick.dart';
import 'package:pilsbot/components/Loading.dart';
import 'package:pilsbot/components/LightsSwitch.dart';
import 'package:pilsbot/components/BatteryState.dart';

class ControlScreen extends StatefulWidget {

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  /// Tell if the app is connected with the pilsbot
  bool connected = false;
  /// How often do we want to reach the pilsbot when we are not connected?
  int period = 1000; // milliseconds
  /// Timer to verify connection to the pilsbot every period of time
  Timer timer;

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      var response = await restGet(restGetControlState);
      //print(connected);
      if(response['error'] == connected) {
        // changed from connected to not connected or vice versa
        setState(() {
          connected = !connected;
        });
      }
    });
  }

  Container showControlPage(){
    return Container(
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SoundBar(),
                  BatteryState(),
                ]
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Joystick(name: 'left'),
                ]
              )
          ],),
          Container(
            width: MediaQuery.of(context).size.width*0.6,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              EmergencySwitch(),
              ControlModeSwitch(),
              LightsSwitch(),
              Container(height: MediaQuery.of(context).size.width*0.16),
              Joystick(name: 'right'),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* Fix landscape mode */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: restGet('controlstate'),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (connected) {
            return showControlPage();
          } else {
            return Loading();
          }
        }
      )
    );
  }

  @override
  void dispose() {
    /* Let all orientation mode for the other pages */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }
}

