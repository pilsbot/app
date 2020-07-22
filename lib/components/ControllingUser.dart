
import 'package:flutter/material.dart';
class ControllingUser extends StatefulWidget {
  @override
  _ControllingUserState createState() => _ControllingUserState();
}

class _ControllingUserState extends State<ControllingUser> {
  /// Name of the user that controls the robot
  String username = '?';

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width*0.2,
        height: MediaQuery.of(context).size.height*0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.drive_eta,
              size: 30.0,
              color: Colors.blue,
            ),
            Text(username, style: TextStyle(color: Colors.blue),),
          ],
        )
    );
  }
}
