import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';

class EmergencySwitch extends StatefulWidget {
  Ros ros;
  EmergencySwitch({@required  this.ros});

  @override
  _EmergencySwitchState createState() => _EmergencySwitchState();
}

class _EmergencySwitchState extends State<EmergencySwitch> {
  /// Is the system on? -1=don't know, 0=no, 1=yes
  int isOn=-1;
  /// ROS topic to use
  Topic sub;
  Topic pub;

  @override
  void initState(){
    sub = Topic(ros: widget.ros, name: '/system/on', type: "std_msgs/Bool", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: widget.ros, name: '/app/cmd/emergency/stop', type: "std_msgs/Bool", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
          isOn = -1;
          if(snapshot.hasData){
            var value = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
            if (value == true){
              isOn = 1;
            } else {
              isOn = 0;
            }
          }
          Color colorFill;
          Color colorIcon;
          if (isOn == 0) {
            colorFill = Colors.blue;
            colorIcon = Colors.orange;
          } else if(isOn == 1) {
            colorFill = Colors.blue;
            colorIcon = Colors.black54;
          } else { // unknown
            colorFill = Colors.grey;
            colorIcon = Colors.black12;
          }
          return Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.065,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
                  horizontal: MediaQuery
                      .of(context)
                      .size
                      .width * 0.01
              ),
              child: RawMaterialButton(
                onPressed: () {
                  if(isOn == 1){
                    pub.publish({'data': false});
                  } else {
                    pub.publish({'data': true});
                  }
                },
                elevation: 2.0,
                fillColor: colorFill,
                child: Icon(
                  Icons.power_settings_new,
                  size: 30.0,
                  color: colorIcon,
                ),
                shape: CircleBorder(),
              )
          );
        }
    );
  }
}
