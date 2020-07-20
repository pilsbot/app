import 'package:flutter/material.dart';

class VelocityState extends StatefulWidget {
  @override
  _VelocityStateState createState() => _VelocityStateState();
}

class _VelocityStateState extends State<VelocityState> {
  /// Battery percentage value
  double value = -1.0;
  /// Battery voltage text
  String text = '? m/s';

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    if (value < 0){
      // Unknown speed / no speed info
      color = Colors.redAccent;
      icon = Icons.av_timer;
      text = '? m/s';
    } else {
      // Unknown speed
      color = Colors.blue;
      icon = Icons.av_timer;
      text = value.toString()+'m/s';
    }
    return Container(
      width: MediaQuery.of(context).size.width*0.2,
      height: MediaQuery.of(context).size.height*0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 30.0,
            color: color,
          ),
          Text(text, style: TextStyle(color: color),),
        ],
      )
    );
  }
}
