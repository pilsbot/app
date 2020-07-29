import 'package:flutter/material.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';

class Blinker extends StatefulWidget {
  final String orientation;

  const Blinker({@required this.orientation});

  @override
  _BlinkerState createState() => _BlinkerState();
}

class _BlinkerState extends State<Blinker> {
  /// Are the lights on?
  /// 1=yes, 0=no, -1=no info
  int isOn;

  @override
  void initState(){
    super.initState();
    isOn = -1;
  }

  @override
  Widget build(BuildContext context) {
    String restCall = restBlinker+'_'+widget.orientation;
    return FutureBuilder<Map<String, dynamic>>(
      future: restGet(restCall),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        Color colorFill;
        Color colorIcon;
        IconData icon;
        if(snapshot.hasData){
          if(snapshot.data[restCall] != null){
            if(snapshot.data[restCall]){
              isOn = 1;
            } else {
              isOn = 0;
            }
          } else {
            isOn = -1;
          }
        }
        if(isOn==1){
          colorFill = Colors.grey;
          colorIcon = Colors.orange;
          if(widget.orientation == 'right'){
            icon = Icons.arrow_right;
          } else {
            icon = Icons.arrow_left;
          }
        } else if(isOn==0){
          colorFill = Colors.blue;
          colorIcon = Colors.black54;
          if(widget.orientation == 'right'){
            icon = Icons.arrow_right;
          } else {
            icon = Icons.arrow_left;
          }
        } else { // unknown status
          colorFill = Colors.blue;
          colorIcon = Colors.black54;
          icon = Icons.remove_red_eye;
        }
        return Container(
          width: MediaQuery.of(context).size.width*0.065,
          height: MediaQuery.of(context).size.height*0.1,
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height*0.01,
            horizontal: MediaQuery.of(context).size.width*0.01
          ),
          child: RawMaterialButton(
            onPressed: () async {
              Map<String, dynamic> value;
              if(isOn==1){
                value = await restPost(restCall, {restCall: false});
              } else {
                value = await restPost(restCall, {restCall: true});
              }
              if(value[restError]) {
                setState(() => isOn = -1);
              } else {
                if(value[restCall]) {
                  setState(() => isOn = 1);
                } else {
                  setState(() => isOn = 0);
                }
              }
            },
            elevation: 2.0,
            fillColor: colorFill,
            child: Icon(
              icon,
              size: 30.0,
              color: colorIcon,
            ),
            shape: CircleBorder(),
          )
        );
      }
    );
  }
}
