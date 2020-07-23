import 'package:flutter/material.dart';
import 'package:pilsbot/model/Common.dart';
import 'package:pilsbot/model/Communication.dart';

class VelocityState extends StatefulWidget {
  @override
  _VelocityStateState createState() => _VelocityStateState();
}

class _VelocityStateState extends State<VelocityState> {
  /// Actual velocity
  double value = 69420.0;
  /// Maximum velocity value accepted.
  double maxVal = 5.0; // m/s
  /// Minimum velocity value accepted.
  double minVal = -5.0; // m/s
  /// Text that will show the velocity.
  String text = '? m/s';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: restGet(restVelocity),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if(snapshot.hasData){
          if(snapshot.data[restVelocity] != null){
            value = snapshot.data[restVelocity];
          } else {
            value = 69420.0;
          }
        }
        Color color;
        IconData icon;
        if (value > maxVal || value < minVal){
          // Unknown speed / no speed info
          color = Colors.blue;
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
    );
    }
}
