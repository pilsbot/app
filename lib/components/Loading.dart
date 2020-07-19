import 'package:flutter/material.dart';
import 'package:pilsbot/model/Communication.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Center(
            child: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    child: Text(
                        'Connecting...',
                        style: TextStyle(
                          color: Colors.blue,
                        )
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
