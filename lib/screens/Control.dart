import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/components/ControlModeSwitch.dart';
import 'package:pilsbot/components/ControllingUser.dart';
import 'package:pilsbot/components/EmergencySwitch.dart';
import 'package:pilsbot/components/VelocityState.dart';
import 'package:pilsbot/components/Blinker.dart';
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
      var response = await restGet(restControlState);
      if(response[restError] == connected) {
        // changed from connected to not connected or vice versa
        setState(() => connected = !connected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /* Fix landscape mode */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    Loading loading = null;
    if (!connected) { loading = Loading(); }
    return Scaffold(
      body: Container(
            color: Colors.black,
            child: Row(
              children: <Widget>[
                Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SoundBar(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(height: MediaQuery.of(context).size.height*0.08),
                          VelocityState(),
                          BatteryState(),
                          ControllingUser(),
                        ],
                      )
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
                  width: MediaQuery.of(context).size.width*0.52,
                  child: loading
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    EmergencySwitch(),
                    ControlModeSwitch(),
                    LightsSwitch(),
                    Container(height: MediaQuery.of(context).size.width*0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Blinker(orientation: 'left'),
                        Blinker(orientation: 'right'),
                      ],
                    ),
                    Container(height: MediaQuery.of(context).size.width*0.04),
                    Joystick(name: 'right'),
                  ],
                )
              ],
            ),
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

