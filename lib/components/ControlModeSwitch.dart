import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';

class ControlModeSwitch extends StatefulWidget {
  @override
  _ControlModeSwitchState createState() => _ControlModeSwitchState();
}

class _ControlModeSwitchState extends State<ControlModeSwitch> {
  /// Steering modus:
  /// modus == 0 -> use one joystick on the left. The right joystick disapear
  /// modus == 1 -> use two joysticks. left joy=throttle. right joy = direction
  /// modus == 2 -> autonomic modus -> no manual control
  int modus=1;

  @override
  Widget build(BuildContext context) {
    Color colorFill;
    Color colorText;
    String text;
    if(modus == 0){
      colorFill = Colors.blue;
      colorText = Colors.black54;
      text = 'M1';
    } else if (modus == 1){
      colorFill = Colors.blue;
      colorText = Colors.black54;
      text = 'M2';
    } else {
      colorFill = Colors.grey;
      colorText = Colors.black26;
      text = 'MA';
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
            restPost('controlmode', modus); // TODO adapt interface
            setState(() {
              modus = modus+1;
              if(modus > 2){
                modus = 0;
              }
            });
          },
          elevation: 2.0,
          fillColor: colorFill,
          child: Text(
            text,
            style: TextStyle(
              color: colorText,
              fontWeight: FontWeight.bold
            ),
          ),
          shape: CircleBorder(),
        )
    );
  }
}
