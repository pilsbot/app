import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:pilsbot/model/Communication.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  /// Tell if the app is connected with the pilsbot
  bool connected = false;
  /// What is the pilsbot current sound volume
  double volume = 0;
  /// This attribute stores the old volume value when the pilsbot is muted
  /// in order to know which volume to take when un-muting
  double savedVolume = 0;
  /// Is the pilsbot sound muted?
  bool mute = false; // mute volume
  /// The joystick refresh minimum period
  Duration joystickRefreshPeriod = Duration(milliseconds: 100);
  /// How often do we want to reach the pilsbot when we are not connected?
  Duration tryToReachServerPeriod = Duration(seconds: 2);

  void checkStatusChanged(int statusCode) {
    // Change state if there is a change in the connection status
    if (statusCode != 200 && connected) {
      setState(() {
        connected = false;
      });
    }
    if (statusCode == 200 && !connected) {
      setState(() {
        connected = true;
      });
    }
  }

  Future<bool> send(id, params) async {
    bool response = await restPost(id, params);
    // Change state if there is a change in the connection status
    if(response != connected){
      setState((){ connected = response; });
    }
    return connected;
  }

  Future<Map<String, dynamic>> read(id) async{
    Map<String, dynamic> response = await restGet(id);
    if(response['error'] == true){
      // Change state if there was an error
      if(connected) {
        setState(() { connected = false; });
      }
      return null;
    }
    if(!connected) {
      setState(() { connected = true; });
    }
    return response;
  }

  Container showControlPage(){
    return Container(
      color: Colors.black,
      child: Row(
        children: <Widget>[
          showSoundBar(),
          Container(width: 50),
          showJoystick(),
        ],
      ),
    );
  }

  Column showSoundBar(){
    Icon icon;
    if(volume == 0 || mute){
      icon = Icon(Icons.volume_off, color: Colors.blue, size: 40);
    } else {
      icon = Icon(Icons.volume_up, color: Colors.blue, size: 40);
    }
    return Column(
      children: <Widget>[
        RotatedBox(
          quarterTurns: -1,
          child: Slider(
            value: volume,
            activeColor: Colors.blue,
            onChanged: (v){
              send('volume', v);
              setState(() { volume = v; });
            },
          )
        ),
        IconButton(
          icon: icon,
          onPressed: (){
            setState(() {
              mute = !mute;
              if(!mute){
                // Restore old volume after un-muting
                volume = savedVolume;
                send('volume', savedVolume);
              } else {
                // Save the old volume for later and mute
                savedVolume = volume;
                volume = 0;
              }
              send('volume', volume);
            });
          },
        ),
      ],
    );
  }

  JoystickView showJoystick() {
    return JoystickView(
      backgroundColor: Colors.blue,
      innerCircleColor: Colors.blue,
      interval: joystickRefreshPeriod,
      showArrows: true,
      onDirectionChanged: (degree, distance) {
        double v = degree * 0.01745329252; // ( * pi / 180 )
        this.send('joystick', {'x': distance*sin(v), 'y': distance*cos(v)});
      },
    );
  }

  // TODO: loading indicator over disable control page instead of all changes
  Container showLoadingIndicator() {
    return Container(
        color: Colors.black,
        child: Center(
            child: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    child: Text(
                        'Connecting...',
                        style: TextStyle(
                          color: Colors.blue,
                        )
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: this.read('controlstate'),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(snapshot.hasData){
            volume = snapshot.data['volume'];
          }
          if (this.connected) {
            return showControlPage();
          } else {
            // Try to reach the server every 5 seconds
            Timer.periodic(tryToReachServerPeriod, (timer) async{
              Map<String, dynamic> state = await read('controlstate');
              if(state != null){
                if (state['error'] == false) {
                  timer.cancel();
                }
              }
            });
            return showLoadingIndicator();
          }
        }
      )
    );
  }
}

