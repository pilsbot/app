import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/screens/Control.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username;
  String _password;
  String _url;
  var com;
  Timer timer;
  int period = 200;

  @override
  void initState(){
    _url =  'ws://192.168.178.39:9090';
    com = RosCom();
    super.initState();
  }

  void initConnection(String url) async {
    com.ros.url = url;
    com.ros.connect();
    setState(() {});

    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      if(com.ros.status == Status.CONNECTED){
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ControlScreen()),
        );
      }
    });
  }

  void destroyConnection() async {
    await com.ros.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    myController.text = _url;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        padding:  EdgeInsets.fromLTRB(140, 20, 140, 0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  fillColor: Colors.blue,
                  focusColor: Colors.blue,
                  hoverColor: Colors.orange,
                ),
                controller: myController,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 3, 100, 3),
                child: ElevatedButton(
                  onPressed: () {
                    this.initConnection(myController.text);
                    },
                  child: Text('Submit', style:  TextStyle(fontSize: 20, color: Colors.white70)),
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
