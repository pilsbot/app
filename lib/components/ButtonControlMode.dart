import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class ButtonControlMode extends StatefulWidget {
  ButtonControlMode();

  @override
  _ButtonControlModeState createState() => _ButtonControlModeState();
}

class _ButtonControlModeState extends State<ButtonControlMode> {
  /// Steering modus:
  /// modus == {unknown, automatic, one_joystick, two_joysticks}
  String modus='unknown';
  /// ROS topics
  Topic sub;
  Topic pub;
  /// Communication with ROS
  var com;

  @override
  void initState(){
    com = RosCom();
    sub = Topic(ros: com.ros, name: '/control/mode', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: com.ros, name: '/app/cmd/control/mode', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    initConnection();
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
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: sub.subscription,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          modus = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
        }
        String text;
        Color colorFill = Colors.blue;
        Color colorText = Colors.black54;
        if(modus == 'one_joystick'){
          text = 'M1';
        } else if (modus == 'two_joysticks'){
          text = 'M2';
        } else if (modus == 'automatic'){
          text = 'MA';
          colorText = Colors.orange;
        } else {
          colorFill = Colors.grey;
          colorText = Colors.black12;
          text = 'M?';
        }
        return Container(
            width: MediaQuery.of(context).size.width*0.065,
            height: MediaQuery.of(context).size.height*0.1,
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height*0.01,
                horizontal: MediaQuery.of(context).size.width*0.01
            ),
            child: RawMaterialButton(
              onPressed: () {
                setState(() {
                  if(modus=='one_joystick'){
                    pub.publish({'data': 'two_joysticks'});
                  } else if(modus=='two_joysticks') {
                    pub.publish({'data': 'automatic'});
                  } else if(modus=='automatic'){
                    pub.publish({'data': 'one_joystick'});
                  } else { // unknown
                    pub.publish({'data': 'automatic'});
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
    );
  }
}
