import 'package:flutter/material.dart';
import 'package:pilsbot/screens/Options.dart';

class ButtonSettings extends StatefulWidget {
  ButtonSettings();

  @override
  _ButtonSettingsState createState() => _ButtonSettingsState();
}

class _ButtonSettingsState extends State<ButtonSettings> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
          Color colorFill = Colors.blue;
          Color colorIcon = Colors.black54;
          return Container(
              width: MediaQuery.of(context).size.width*0.1,
              height: MediaQuery.of(context).size.height*0.15,
              padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width*0, 0),
              child: RawMaterialButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OptionsScreen()),
                  );
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
