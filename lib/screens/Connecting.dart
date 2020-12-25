import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pilsbot/screens/Login.dart';
import 'package:roslib/roslib.dart';
import 'package:pilsbot/components/Loading.dart';
import 'package:pilsbot/screens/Control.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pilsbot/model/Communication.dart';
import 'package:global_configuration/global_configuration.dart';

class ConnectingScreen extends StatefulWidget {
  @override
  _ConnectingScreenState createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  var com;

  @override
  void initState(){
    var url = "ws://"+GlobalConfiguration().getValue("server_ip")+":"+GlobalConfiguration().getValue("server_port_websocket");
    GlobalConfiguration().updateValue("error_msg", "");
    com = RosCom();
    com.ros.url = url;
    com.ros.connect();
    print(url);
    super.initState();
    Future.delayed(Duration(milliseconds: 3000), () {
      if(com.ros.status == Status.CONNECTED){
        print("connected");
        Navigator.of(context).push(_createRouteToControlScreen());
      } else{
        String err = AppLocalizations.of(context).connection_failed.toString();
        print(err);
        GlobalConfiguration().updateValue("error_msg", err);
        Navigator.of(context).push(_createRouteToLoginScreen());
      }
    });
  }

  Route _createRouteToControlScreen() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1300),
      pageBuilder: (context, animation, secondaryAnimation) => ControlScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(3.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
          child: child,
        );
      },
    );
  }

  Route _createRouteToLoginScreen() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1300),
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(-3.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
          child: child,
        );
      },
    );
  }

  void destroyConnection() async {
    await com.ros.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
      body: Loading(
        text: AppLocalizations.of(context).connecting
      )
    );
  }

  @override
  void dispose() {
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
