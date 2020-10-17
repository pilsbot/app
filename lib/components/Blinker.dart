import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';

import 'BlinkingWidget.dart';

class Blinker extends StatefulWidget {
  final String orientation;
  Ros ros;

  Blinker({@required  this.ros, @required this.orientation});

  @override
  _BlinkerState createState() => _BlinkerState();
}

class _BlinkerState extends State<Blinker> {
  /// Are the lights on?
  /// 1=yes, 0=no, -1=no info
  int isOn;
  /// ROS topics to use
  Topic sub;
  Topic pub;
  /// Icon that will be shown (left or right blinker)
  IconData icon;

  @override
  void initState(){
    sub = Topic(ros: widget.ros, name: '/lighting/indicator/'+widget.orientation, type: "std_msgs/Bool", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: widget.ros, name: '/app/cmd/lighting/indicator/'+widget.orientation, type: "std_msgs/Bool", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
        Color colorFill;
        Color colorIcon;
        isOn = -1;
        if(snapshot.hasData){
          var value = Map<String, dynamic>.from(Map<String, dynamic>.from(snapshot.data)['msg'])['data'];
          if(value == true){
            isOn = 1;
          } else {
            isOn = 0;
          }
        }
        if(isOn==1){
          colorFill = Colors.blue;
          colorIcon = Colors.orange;
        } else if(isOn==0){
          colorFill = Colors.blue;
          colorIcon = Colors.black54;
        } else { // unknown status
          colorFill = Colors.grey;
          colorIcon = Colors.black12;
        }
        IconData icon;
        if(widget.orientation == 'right'){
          icon = Icons.arrow_right;
        } else {
          icon = Icons.arrow_left;
        }
        List<Widget> widgets = List<Widget>();
        widgets.clear();
        widgets.add(Icon(icon, size: 30.0, color: colorIcon));
        if(isOn==1)
        {
          widgets.add(Icon(icon, size: 30.0, color: Colors.transparent));
        }
        return Container(
          width: MediaQuery.of(context).size.width*0.065,
          height: MediaQuery.of(context).size.height*0.1,
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height*0.01,
            horizontal: MediaQuery.of(context).size.width*0.01
          ),
          child: RawMaterialButton(
            onPressed: () async {
              if(isOn==1){
                pub.publish({'data': false});
              } else {
                pub.publish({'data': true});
              }
            },
            elevation: 2.0,
            fillColor: colorFill,
            child: BlinkWidget(
              children: widgets,
            ),
            shape: CircleBorder(),
          )
        );
      }
    );
  }
}
