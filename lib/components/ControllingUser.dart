import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';

class ControllingUser extends StatefulWidget {
  Ros ros;
  ControllingUser({@required this.ros});

  @override
  _ControllingUserState createState() => _ControllingUserState();
}

class _ControllingUserState extends State<ControllingUser> {
  Topic topic;

  @override
  void initState(){
    topic = Topic(ros: widget.ros, name: '/app/driver', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
