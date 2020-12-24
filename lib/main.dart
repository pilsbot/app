import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:pilsbot/screens/Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {
  runApp(MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', ''),
      const Locale('fr', ''),
      const Locale('de', ''),
    ],
    title: 'PilsBot',
    home: LoginScreen(),
  ));
}
