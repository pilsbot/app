import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilsbot/screens/Connecting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonConnect extends StatelessWidget {

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1300),
      pageBuilder: (context, animation, secondaryAnimation) => ConnectingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var offsetAnimation = animation.drive(Tween(begin: Offset(3.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)));
        return SlideTransition(
          position: offsetAnimation,
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
        width: MediaQuery.of(context).size.width*0.4,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width*0.4),
        ),
        child: Text(AppLocalizations.of(context).login,
          style: TextStyle(
            fontSize: 24,
            color: Colors.black54
          ),
        ),
      )
    );
  }
}