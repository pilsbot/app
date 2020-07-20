import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';

class ControlModeSwitch extends StatefulWidget {
  @override
  _ControlModeSwitchState createState() => _ControlModeSwitchState();
}

class _ControlModeSwitchState extends State<ControlModeSwitch> {
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
      colorIcon = Colors.black;
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
            restPost('emergencystop', !pressed);
            setState(() {
              pressed = !pressed;
            });
          },
          elevation: 2.0,
          fillColor: colorFill,
          child: Icon(
            Icons.directions_car,
            size: 30.0,
            color: colorIcon,
          ),
          shape: CircleBorder(),
        )
    );
  }
}
