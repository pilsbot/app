import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/components/ButtonControlMode.dart';
import 'package:pilsbot/components/StateDriver.dart';
import 'package:pilsbot/components/ButtonOnOff.dart';
import 'package:pilsbot/components/ButtonParty.dart';
import 'package:pilsbot/components/StateSpeed.dart';
import 'package:pilsbot/components/ButtonBlinker.dart';
import 'package:pilsbot/components/SoundBar.dart';
import 'package:pilsbot/components/Joystick.dart';
import 'package:pilsbot/components/ButtonSettings.dart';
import 'package:pilsbot/components/ButtonHeadlight.dart';
import 'package:pilsbot/components/StateBattery.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:pilsbot/screens/Login.dart';
import 'package:roslib/roslib.dart';
//import 'package:image/image.dart' as Image;

class ControlScreen extends StatefulWidget {

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  var com;
  Topic cameraStream;
  Topic joystickStream;
  Timer timer;
  int period = 1000;

  @override
  void initState(){
    com = RosCom();
    super.initState();
    initConnection();
    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      if(com.ros.status != Status.CONNECTED){
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  void initConnection() async {
    cameraStream = Topic(ros: com.ros, name: '/usb_cam/image_raw', type: "sensor_msgs/Image", reconnectOnClose: true, queueLength: 200, queueSize: 200);
    joystickStream = Topic(ros: com.ros, name: '/app/cmd/joystick', type: "sensor_msgs/Joy", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    //await cameraStream.subscribe();
    setState(() {});
  }

  void destroyConnection() async {
    await com.ros.close();
    //await cameraStream.unsubscribe();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /* Fix landscape mode */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            StreamBuilder<Object>(
              stream: cameraStream.subscription,
              builder: (context, snapshot) {
                //Image.Image cameraImage;
                //Image.Image background;
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
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SoundBar(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(height: MediaQuery.of(context).size.height*0.08),
                            StateSpeed(),
                            StateBattery(),
                            StateDriver(),
                            ButtonSettings(),
                          ],
                        )
                      ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ButtonControlMode(),
                            ButtonOnOff(),
                          ],
                        ),
                        Row(
<<<<<<< HEAD
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ButtonHeadlight(),
                            ButtonParty(),
                          ],
                        ),
                        Container(height: MediaQuery.of(context).size.width*0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
=======
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ButtonHeadlight(),
                            ButtonParty(),
                          ],
                        ),
                        Container(height: MediaQuery.of(context).size.width*0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> a27b5c8fb04e50e32acda5fb05e31597b56dcf83
                          children: <Widget>[
                            ButtonBlinker(orientation: 'left'),
                            ButtonBlinker(orientation: 'right'),
                          ],
                        ),
                      ],
                    ),
                    //Container(height: MediaQuery.of(context).size.width*0.04),
                  ],
                ),
                Joystick(),
              ],
            ),
          ],
        )
      )
    );
  }

  @override
  void dispose() {
    timer.cancel();
    destroyConnection();
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
