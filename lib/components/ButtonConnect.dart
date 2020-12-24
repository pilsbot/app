import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pilsbot/screens/Options.dart';
import 'dart:io';
import 'package:roslib/roslib.dart';
import 'package:pilsbot/screens/Control.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonConnect extends StatefulWidget {
  ButtonConnect();

  @override
  _ButtonConnectState createState() => _ButtonConnectState();
}

class _ButtonConnectState extends State<ButtonConnect> {
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

  void destroyConnection() async {
    await com.ros.close();
    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    destroyConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.4,
      height: MediaQuery.of(context).size.height*0.15,
      child: RawMaterialButton(
        fillColor: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.4),
        ),
        onPressed: () async {
          var url = "ws://"+GlobalConfiguration().getValue("server_ip")+":"+GlobalConfiguration().getValue("server_port_websocket");
          print(url);
          com.ros.url = url;
          com.ros.connect();
          setState(() {});
        },
        child: Text(AppLocalizations.of(context).login, style:
          TextStyle(fontSize: 24, color: Colors.black54),
        ),
      )
    );
  }
}
