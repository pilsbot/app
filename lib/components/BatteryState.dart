import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';

class BatteryState extends StatefulWidget {
  Ros ros;
  BatteryState({@required this.ros});

  @override
  _BatteryStateState createState() => _BatteryStateState();
}

class _BatteryStateState extends State<BatteryState> {
  /// Battery percentage value
  int value = -1;
  /// Battery voltage text
  String text = '?%';
  /// Warning value. If the battery percentage is under this value,
  /// the battery icon will be shown in red with a warning sign
  final int warning = 20;
  /// Ros topic to listen to
  Topic topic;

  @override
  void initState(){
    topic = Topic(ros: widget.ros, name: '/battery/percentage', type: "std_msgs/Float32", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
        if (snapshot.hasData)
        {
          // Workaround to for the convertion from object to json
          value = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'].round();
        }
        Color color;
        IconData icon;
        if (value >= 0 && value <= warning){
          color = Colors.redAccent;
          icon = Icons.battery_alert;
          text = value.toString()+'%';
        } else if (value > warning && value <= 100){
          color = Colors.blue;
          icon = Icons.battery_std;
          text = value.toString()+'%';
        } else {
          // Unknown battery percentage
          color = Colors.grey;
          icon = Icons.battery_unknown;
          text = '?%';
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
