import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:roslib/roslib.dart';

class Joystick extends StatefulWidget {
  Ros ros;

  Joystick({@required this.ros});

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  /// x value of the left joystick
  double xl=0;
  /// y value of the left joystick
  double yl=0;
  /// x value of the right joystick
  double xr=0;
  /// y value of the right joystick
  double yr=0;
  /// The joystick refresh minimum period in milliseconds
  int period = 200;
  /// Timer that sends out joystick values every period of time
  Timer timer;
  /// ROS topics to use
  Topic pub;

  @override
  void initState(){
    pub = Topic(ros: widget.ros, name: '/app/cmd/joystick', type: "sensors_msgs/Joy", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      var msg = {'axes': [xl, yl, xr, yr]};
      pub.publish(msg);
    });
  }

  @override
  void dispose(){
    timer.cancel(); // TODO: not always working
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          JoystickView(
            size:MediaQuery.of(context).size.height*0.32,
            backgroundColor: Colors.blue,
            innerCircleColor: Colors.blue,
            iconsColor: Colors.black54,
            interval: Duration(milliseconds: 100),
            showArrows: false,
            onDirectionChanged: (degree, distance) {
              double v = degree * 0.01745329252; // ( * pi / 180 )
              xl = distance*sin(v);
              yl = distance*cos(v);
            },
          ),
          JoystickView(
            size:MediaQuery.of(context).size.height*0.32,
            backgroundColor: Colors.blue,
            innerCircleColor: Colors.blue,
            iconsColor: Colors.black54,
            interval: Duration(milliseconds: 100),
            showArrows: false,
            onDirectionChanged: (degree, distance) {
              double v = degree * 0.01745329252; // ( * pi / 180 )
              xr = distance*sin(v);
              yr = distance*cos(v);
            },
          ),
        ]
      )
    );
  }
}
