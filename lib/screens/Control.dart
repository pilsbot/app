import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:pilsbot/model/Communication.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool connected = false;
  double volume = 0;
  final int joystickRefreshPeriod = 100; // milliseconds

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
    return Column(
      children: <Widget>[
        RotatedBox(
          quarterTurns: -1,
          child: Slider(
            value: this.volume,
            activeColor: Colors.blue,
            onChanged: (v){
              send('volume', v);
            },
          )
        ),
        Icon(
          Icons.volume_up,
          color: Colors.blue,
          size: 40,
        ),
      ],
    );
  }

  JoystickView showJoystick() {
    return JoystickView(
      backgroundColor: Colors.blue,
      innerCircleColor: Colors.blue,
      interval: Duration(milliseconds: joystickRefreshPeriod),
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
            return showLoadingIndicator();
          }
        }
      )
    );
  }
}

