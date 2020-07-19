import 'package:flutter/material.dart';
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
      colorFill = Colors.redAccent;
      colorIcon = Colors.black;
    }
    return Container(
      child: RawMaterialButton(
        onPressed: () {
          restPost('emergencystop', !pressed);
          setState(() {
            pressed = !pressed;
          });
        },
        elevation: 2.0,
        fillColor: colorFill,
        child: Icon(
          Icons.power_settings_new,
          size: 40.0,
          color: colorIcon,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      )
    );
  }
}
