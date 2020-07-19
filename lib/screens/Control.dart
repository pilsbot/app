import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pilsbot/components/EmergencySwitch.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:pilsbot/components/SoundBar.dart';
import 'package:pilsbot/components/Joystick.dart';
import 'package:pilsbot/components/Loading.dart';

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
      var response = await restGet('controlstate');
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
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SoundBar(),
              EmergencySwitch(),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Joystick(),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
}

