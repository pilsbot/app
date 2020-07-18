import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:http/http.dart' as http;

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool connected = false;
  final String serverAddress = 'http://192.168.178.38:5000/';
  final int serverTimeout = 2; // sec
  final int joystickRefreshPeriod = 100; // milliseconds
  final Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };

  Future<bool> send(id, params) async {
    try {
      http.Response res = await http.post(
        serverAddress + id,
        headers: headers,
        body: json.encode(params),
      ).timeout(
          Duration(seconds: serverTimeout),
          onTimeout: () {
            connected = false;
            return null;
          }
      );
      // Change state if there is a change in the connection status
      if(res.statusCode != 200 && connected){
        setState((){ connected = false; });
      }
      if(res.statusCode == 200 && !connected){
        setState((){ connected = true; });
      }
    } catch (_){
      // TODO: what to do in case of socket exception? retry connection? go to home page?
      if(connected) {
        setState(() { connected = false; });
      }
    }
    return connected;
  }

  Container showJoystick() {
    return Container(
      color: Colors.black,
      child: JoystickView(
        backgroundColor: Colors.blue,
        innerCircleColor: Colors.blue,
        interval: Duration(milliseconds: joystickRefreshPeriod),
        showArrows: true,
        onDirectionChanged: (degree, distance) {
          double v = degree * 0.01745329252; // ( * pi / 180 )
          this.send('joystick', {'x': distance*sin(v), 'y': distance*cos(v)});
        },
      ),
    );
  }

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
      body: FutureBuilder<bool>(
        future: this.send('joystick', {'x': 0, 'y': 0}),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (this.connected) {
            return showJoystick();
          } else {
            return showLoadingIndicator();
          }
        }
      )
    );
  }
}

