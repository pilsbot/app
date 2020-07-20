import 'package:flutter/material.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';

class EmergencySwitch extends StatefulWidget {
  @override
  _EmergencySwitchState createState() => _EmergencySwitchState();
}

class _EmergencySwitchState extends State<EmergencySwitch> {
  /// Is the button pressed or not?
  bool pressed=false;

  @override
  Widget build(BuildContext context) {
    Color colorFill;
    Color colorIcon;
    if(pressed){
      colorFill = Colors.grey;
      colorIcon = Colors.black26;
    } else {
      colorFill = Colors.blue;
      colorIcon = Colors.black54;
    }
    return Container(
      width: MediaQuery.of(context).size.width*0.1,
      height: MediaQuery.of(context).size.height*0.1,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height*0.01,
        horizontal: MediaQuery.of(context).size.width*0.01
      ),
      child: RawMaterialButton(
        onPressed: () {
          restPost(restSetEmergencyStop, !pressed);
          setState(() {
            pressed = !pressed;
          });
        },
        elevation: 2.0,
        fillColor: colorFill,
        child: Icon(
          Icons.power_settings_new,
          size: 30.0,
          color: colorIcon,
        ),
        shape: CircleBorder(),
      )
    );
  }
}
