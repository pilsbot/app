import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class Joystick extends StatefulWidget {
  Joystick();

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
  Topic sub;
  /// Communication with ROS
  var com;
  /// Steering mode:
  /// mode == {unknown, automatic, one_joystick, two_joysticks}
  String mode='two_joysticks';

  @override
  void initState(){
    com = RosCom();
    pub = Topic(ros: com.ros, name: '/app/cmd/joystick', type: "sensors_msgs/Joy", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    sub = Topic(ros: com.ros, name: '/control/mode', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    initConnection();
    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      var msg = {'header': {'frame_id': 'app_joystick'}, 'axes': [xl, yl, xr, yr, 0, 0], 'buttons': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]};
      pub.publish(msg);
    });
  }

  void initConnection() async {
    await sub.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await sub.unsubscribe();
    setState(() {});
  }

  @override
  void dispose(){
    timer.cancel(); // TODO: not always working
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: sub.subscription,
      builder: (context, snapshot)
      {
        if(snapshot.hasData){
          mode = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
        }
        List<Widget> widgets = List<Widget>();
        if(mode == 'one_joystick' || mode == 'two_joysticks'){
          widgets.add(
            JoystickView(size: MediaQuery.of(context).size.height * 0.32,
              backgroundColor: Colors.blue,
              innerCircleColor: Colors.blue,
              iconsColor: Colors.black54,
              interval: Duration(milliseconds: 100),
              showArrows: false,
              onDirectionChanged: (degree, distance) {
                double v = degree * 0.01745329252; // ( * pi / 180 )
                xl = distance * sin(v);
                yl = distance * cos(v);
              },
            )
          );
        }
        if (mode == 'two_joysticks'){
          widgets.add(
              JoystickView(size: MediaQuery.of(context).size.height * 0.32,
                backgroundColor: Colors.blue,
                innerCircleColor: Colors.blue,
                iconsColor: Colors.black54,
                interval: Duration(milliseconds: 100),
                showArrows: false,
                onDirectionChanged: (degree, distance) {
                  double v = degree * 0.01745329252; // ( * pi / 180 )
                  xr = distance * sin(v);
                  yr = distance * cos(v);
                },
              )
          );
        } else {
          widgets.add(Container());
        }
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widgets
          )
        );
      }
    );
  }
}
