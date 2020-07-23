import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';

class ControllingUser extends StatefulWidget {
  @override
  _ControllingUserState createState() => _ControllingUserState();
}

class _ControllingUserState extends State<ControllingUser> {
  /// Name of the user that controls the robot
  String username = '?';
  /// Timer to get battery state every time period
  Timer timer;
  /// How often do we want to check the velocity?
  int period = 1; // seconds

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(seconds: period), (tim) async{
      var response = await restGet(restDrivingUser);
      if(response[restDrivingUser] != null) {
        if (response[restDrivingUser] != username) {
          setState(() => username = response[restDrivingUser]);
        }
      } else {
        setState(() => username = '?');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.2,
      height: MediaQuery.of(context).size.height*0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.drive_eta,
            size: 30.0,
            color: Colors.blue,
          ),
          Text(username, style: TextStyle(color: Colors.blue),),
        ],
      )
    );
  }
}
