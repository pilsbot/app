import 'dart:math';
import 'package:flutter/material.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:http/http.dart' as http;

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool connected = false;
  final String serverIp = '192.168.178.38';
  final int serverTimeout = 2; // sec

  Future<bool> send(id, values) async {
    var params = {"type": id, "values": values};
    http.Response res = await http.post(
        serverIp,
        body: params,
        headers: {
          "Accept": "application/json"
        }
    );
    // Change state if there is a change in the connection status
    if(res.statusCode != 200 && connected){
      setState((){ connected = false; });
    }
    if(res.statusCode == 200 && !connected){
      setState((){ connected = true; });
    }
    return connected;
  }

  Container showJoystick() {
    return Container(
      color: Colors.black,
      child: JoystickView(
        backgroundColor: Colors.blue,
        innerCircleColor: Colors.blue,
        interval: Duration(milliseconds: 100),
        showArrows: true,
        onDirectionChanged: (degree, distance) {
          double v = degree * 0.01745329252; // ( * pi / 180 )
          this.send('joystick', [sin(v), cos(v)]);
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
        future: this.send(0, [0,0]),
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

