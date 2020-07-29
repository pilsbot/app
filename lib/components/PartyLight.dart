import 'package:flutter/material.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';

class PartyLight extends StatefulWidget {
  @override
  _PartyLightState createState() => _PartyLightState();
}

class _PartyLightState extends State<PartyLight> {
  /// Are the lights on?
  /// 1=yes, 0=no, -1=no info
  int isLightOn;

  @override
  void initState(){
    super.initState();
    isLightOn = -1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: restGet(restPartyLightOn),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          Color colorFill;
          Color colorIcon;
          IconData icon;
          if(snapshot.hasData){
            if(snapshot.data[restPartyLightOn] != null){
              if(snapshot.data[restPartyLightOn]){
                isLightOn = 1;
              } else {
                isLightOn = 0;
              }
            } else {
              isLightOn = -1;
            }
          }
          if(isLightOn==1){
            colorFill = Colors.grey;
            colorIcon = Colors.orange;
            icon = Icons.whatshot;
          } else if(isLightOn==0){
            colorFill = Colors.blue;
            colorIcon = Colors.black54;
            icon = Icons.whatshot;
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
                  if(isLightOn==1){
                    value = await restPost(restPartyLightOn, {restPartyLightOn: false});
                  } else {
                    value = await restPost(restPartyLightOn, {restPartyLightOn: true});
                  }
                  if(value[restError]) {
                    setState(() => isLightOn = -1);
                  } else{
                    if(value[restPartyLightOn]) {
                      setState(() => isLightOn = 1);
                    } else {
                      setState(() => isLightOn = 0);
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
