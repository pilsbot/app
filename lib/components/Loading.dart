import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final String text;
  Loading({this.text});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0, color: Colors.black54.withOpacity(1)),
        color: Colors.black54.withOpacity(1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.all(16.0),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.blue,
              )
            ),
          ),
        ],
      ),
    );
  }
}
