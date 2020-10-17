import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/components/ControlModeSwitch.dart';
import 'package:pilsbot/components/ControllingUser.dart';
import 'package:pilsbot/components/EmergencySwitch.dart';
import 'package:pilsbot/components/PartyLight.dart';
import 'package:pilsbot/components/VelocityState.dart';
import 'package:pilsbot/components/Blinker.dart';
import 'package:pilsbot/components/SoundBar.dart';
import 'package:pilsbot/components/Joystick.dart';
import 'package:pilsbot/components/Loading.dart';
import 'package:pilsbot/components/LightsSwitch.dart';
import 'package:pilsbot/components/BatteryState.dart';
import 'package:roslib/roslib.dart';
import 'package:image/image.dart' as Image;

class ControlScreen extends StatefulWidget {

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  Ros ros;
  Topic cameraStream;
  Topic joystickStream;

  @override
  void initState(){
    ros = Ros(url: 'ws://192.168.178.39:9090');
    cameraStream = Topic(ros: ros, name: '/usb_cam/image_raw', type: "sensor_msgs/Image", reconnectOnClose: true, queueLength: 200, queueSize: 200);
    joystickStream = Topic(ros: ros, name: '/app/cmd/joystick', type: "sensor_msgs/Joy", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    super.initState();
    initConnection();
  }

  void initConnection() async {
    ros.connect();
    //await cameraStream.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await ros.close();
    //await cameraStream.unsubscribe();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Object>(
        stream: ros.statusStream,
        builder: (context, snapshot) {
          return Container(
            child: Stack(
              children: <Widget>[
                StreamBuilder<Object>(
                  stream: camera_stream.subscription,
                  builder: (context, snapshot) {
                    Image.Image cameraImage;
                    Image.Image background;
                    if(snapshot.hasData){
                      print('has data');
                      print(snapshot.data);
                      /*var msg = Map<String, dynamic>.from(snapshot.data)['msg'];
                      var data = Map<String, dynamic>.from(msg)['data'];
                      var height = Map<String, dynamic>.from(msg)['height'];
                      var width = Map<String, dynamic>.from(msg)['width'];*/
                      //var type = Map<String, dynamic>.from(value)['format'];
                      /*print(height);
                      print(width);*/
                      return Container(color: Colors.black,
                        /*decoration: new BoxDecoration(
                          image: new DecorationImage(image: , fit: BoxFit.cover,),
                        ),*/
                      );
                    }
                    return Container(color: Colors.black);
                  }
                ),
                Row(
                  children: <Widget>[
                    Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SoundBar(ros: ros),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(height: MediaQuery.of(context).size.height*0.08),
                                VelocityState(ros: ros),
                                BatteryState(ros: ros),
                                ControllingUser(ros: ros),
                              ],
                            )
                          ]
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Joystick(ros: ros, name: 'left'),
                          ]
                      )
                    ],),
                    Container(
                        width: MediaQuery.of(context).size.width*0.52,
                        child: Loading(show: false)
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ControlModeSwitch(ros: ros),
                            EmergencySwitch(ros: ros),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LightsSwitch(ros: ros),
                            PartyLight(ros: ros),
                          ],
                        ),
                        Container(height: MediaQuery.of(context).size.width*0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Blinker(ros: ros, orientation: 'left'),
                            Blinker(ros: ros, orientation: 'right'),
                          ],
                        ),
                        Container(height: MediaQuery.of(context).size.width*0.04),
                        Joystick(ros: ros, name: 'right'),
                      ],
                    )
                  ],
                ),
              ],
            )
          );
        }
      )
    );
  }

  @override
  void dispose() {
    /* Let all orientation mode for the other pages */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }
}
