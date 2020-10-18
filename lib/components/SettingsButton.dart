import 'package:flutter/material.dart';

class SettingsButton extends StatefulWidget {
  SettingsButton();

  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
          Color colorFill = Colors.grey;
          Color colorIcon = Colors.black12;
          return Container(
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.height*0.15,
              padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width*0.1, 0),
              child: RawMaterialButton(
                onPressed: () async {
                  // TODO
                },
                elevation: 2.0,
                fillColor: colorFill,
                child: Icon(
                  Icons.settings,
                  size: 40.0,
                  color: colorIcon,
                ),
                shape: CircleBorder(),
              )
          );
  }
}
