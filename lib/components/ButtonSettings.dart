import 'package:flutter/material.dart';
import 'package:pilsbot/screens/Options.dart';

class ButtonSettings extends StatelessWidget {

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1300),
      pageBuilder: (context, animation, secondaryAnimation) => OptionsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(3.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(_createRoute());
      },
      child: Container(
        width: 45,
        height: 45,
        padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width*0, 0),
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle
        ),
        child: Icon(
          Icons.settings,
          size: 38.0,
          color: Colors.black54,
        ),
      )
    );
  }
}
