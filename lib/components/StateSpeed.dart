import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class StateSpeed extends StatefulWidget {
  StateSpeed();

  @override
  _StateSpeedState createState() => _StateSpeedState();
}

class _StateSpeedState extends State<StateSpeed> {
  /// Actual velocity
  double value = 69420.0;
  /// Maximum velocity value accepted.
  double maxVal = 5.0; // m/s
  /// Minimum velocity value accepted.
  double minVal = -5.0; // m/s
  /// Text that will show the velocity.
  String text = '? m/s';
  /// Timer to get velocity every time period
  Timer timer;
  /// How often do we want to check the velocity?
  int period = 1000; // milliseconds
  Topic topic;
  /// Communication with ROS
  var com;

  @override
  void initState(){
    com = RosCom();
    topic = Topic(ros: com.ros, name: '/control/speed', type: "std_msgs/Float32", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    initConnection();
  }

  void initConnection() async {
    await topic.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await topic.unsubscribe();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: topic.subscription,
      builder: (context, snapshot) {
        Color color = Colors.grey;
        if (snapshot.hasData)
        {
          // Workaround to for the convertion from object to json
          value = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
          color = Colors.blue;
        }
        IconData icon;
        if (value > maxVal || value < minVal){
          // Unknown speed / no speed info
          icon = Icons.av_timer;
          text = '? m/s';
        } else {
          // Unknown speed
          icon = Icons.av_timer;
          text = value.toStringAsFixed(1)+'m/s';
        }
        return Container(
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.height*0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                size: 30.0,
                color: color,
              ),
              Text(text, style: TextStyle(color: color),),
            ],
          )
        );
      },
    );
  }
}
