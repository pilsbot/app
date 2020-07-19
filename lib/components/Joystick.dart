import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:pilsbot/model/Communication.dart';

class Joystick extends StatefulWidget {
  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  /// The joystick refresh minimum period in milliseconds
  int period = 200;
  /// x value of the joystick
  double x=0;
  /// y value of the joystick
  double y=0;
  Timer timer;

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      var response = await restPost('joystick', {'x': x, 'y': y});
      if(response['error']) {
        // Do not send data when there is an error.
        // Wait for the parent widget to reload this widget later when
        // the errors are solved
        tim.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: JoystickView(
        backgroundColor: Colors.blue,
        innerCircleColor: Colors.blue,
        interval: Duration(milliseconds: 100),
        showArrows: true,
        onDirectionChanged: (degree, distance) {
          double v = degree * 0.01745329252; // ( * pi / 180 )
          x = distance*sin(v);
          y = distance*cos(v);
        },
      ),
    );
  }
}
