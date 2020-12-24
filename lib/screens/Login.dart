import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/screens/Control.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:roslib/roslib.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var com;
  Timer timer;
  int period = 200;

  @override
  void initState(){
    com = RosCom();
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: period), (tim) async{
      if(com.ros.status == Status.CONNECTED){
        print('connected');
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ControlScreen()),
        );
      }
    });
  }

  Future<bool> initConnection() async {
    await GlobalConfiguration().loadFromAsset("config");
    var url = "ws://"+GlobalConfiguration().getValue("server_ip")+":"+GlobalConfiguration().getValue("server_port_websocket");
    print(url);
    com.ros.url = url;
    com.ros.connect();
    setState(() {});
    return true;
  }

  void destroyConnection() async {
    await com.ros.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        padding: EdgeInsets.fromLTRB(140, 20, 140, 0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 3, 100, 3),
                child: ElevatedButton(
                  onPressed: () {
                    this.initConnection();
                    },
                  child: Text(AppLocalizations.of(context).login, style: TextStyle(fontSize: 20, color: Colors.white70)),
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
    timer.cancel();
    destroyConnection();
    super.dispose();
  }
}
