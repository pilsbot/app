import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class StateDriver extends StatefulWidget {
  StateDriver();

  @override
  _StateDriverState createState() => _StateDriverState();
}

class _StateDriverState extends State<StateDriver> {
  Topic topic;
  /// Communication with ROS
  var com;

  @override
  void initState(){
    com = RosCom();
    topic = Topic(ros: com.ros, name: '/app/driver', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
        String username = "?";
        if (snapshot.hasData)
        {
          // Workaround to for the convertion from object to json
          username = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
          color = Colors.blue;
        }
        return Container(
            width: MediaQuery.of(context).size.width*0.2,
            height: MediaQuery.of(context).size.height*0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.drive_eta,
                  size: 30.0,
                  color: color,
                ),
                Text(username, style: TextStyle(color: color),),
              ],
            )
        );
      },
    );
  }
}
