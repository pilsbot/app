import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class SoundBar extends StatefulWidget {
  SoundBar();

  @override
  _SoundBarState createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
  /// What is the pilsbot current sound volume
  double volume = 0;
  /// This attribute stores the old volume value when the pilsbot is muted
  /// in order to know which volume to take when un-muting
  double savedVolume = 0;
  /// Is the pilsbot sound muted?
  bool mute = false; // mute volume
  /// ROS topics to use
  Topic sub;
  Topic pub;
  /// Communication with ROS
  var com;

  @override
  void initState(){
    com = RosCom();
    sub = Topic(ros: com.ros, name: '/system/sound/', type: "std_msgs/Float32", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    pub = Topic(ros: com.ros, name: '/app/cmd/sound/value/', type: "std_msgs/Float32", reconnectOnClose: true, queueLength: 10, queueSize: 10);
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
    Icon icon;
    if(volume == 0 || mute){
      icon = Icon(Icons.volume_off, color: Colors.grey);
    } else {
      icon = Icon(Icons.volume_up, color: Colors.grey);
    }
    return Container(
      height: MediaQuery.of(context).size.height*0.68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: volume,
                activeColor: Colors.grey,
                onChanged: (v){
                  pub.publish({'data': volume});
                  setState(() { volume = v; });
                },
              )
          ),
          IconButton(
            icon: icon,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            onPressed: (){
              setState(() {
                mute = !mute;
                if(!mute){
                  // Restore old volume after un-muting
                  volume = savedVolume;
                } else {
                  // Save the old volume for later and mute
                  savedVolume = volume;
                  volume = 0;
                }
                pub.publish({'data': volume});
              });
            },
          ),
        ],
      )
    );
  }
}
