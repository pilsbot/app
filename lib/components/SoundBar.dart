import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';

class SoundBar extends StatefulWidget {
  @override
  _SoundBarState createState() => _SoundBarState();
}

class _SoundBarState extends State<SoundBar> {
  /// What is the pilsbot current sound volume
  double volume = 0;
  /// This attribute stores the old volume value when the pilsbot is muted
  /// in order to know which volume to take when un-muting
  double savedVolume = 0;
  /// Is the pilsbot sound muted?
  bool mute = false; // mute volume

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if(volume == 0 || mute){
      icon = Icon(Icons.volume_off, color: Colors.blue);
    } else {
      icon = Icon(Icons.volume_up, color: Colors.blue);
    }
    return Container(
      height: MediaQuery.of(context).size.height*0.68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: volume,
                activeColor: Colors.blue,
                onChanged: (v){
                  restPost(restVolume, {restVolume: v});
                  setState(() { volume = v; });
                },
              )
          ),
          IconButton(
            icon: icon,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            onPressed: (){
              setState(() {
                mute = !mute;
                if(!mute){
                  // Restore old volume after un-muting
                  volume = savedVolume;
                } else {
                  // Save the old volume for later and mute
                  savedVolume = volume;
                  volume = 0;
                }
                restPost(restVolume, {restVolume: volume});
              });
            },
          ),
        ],
      )
    );
  }
}
