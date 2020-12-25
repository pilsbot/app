import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pilsbot/components/SliderOption.dart';
import 'package:pilsbot/components/TextFieldOption.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:global_configuration/global_configuration.dart';

class OptionsScreen extends StatefulWidget {
  OptionsScreen();

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalConfiguration().updateValue("error_msg", "");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Container(
      color: Colors.black,
      width: 500,
      height: 200,
      child: ListView(
        children: <Widget>[
          TextFieldOption(AppLocalizations.of(context).username, 'username'),
          TextFieldOption(AppLocalizations.of(context).password, 'password', true),
          TextFieldOption(AppLocalizations.of(context).server_ip, 'server_ip'),
          TextFieldOption(AppLocalizations.of(context).websocket_port, 'server_port_websocket'),
          TextFieldOption(AppLocalizations.of(context).rest_api_port, 'server_port_rest'),
          SliderOption(AppLocalizations.of(context).joystick_sensitivity, 'joystick_sensitivity'),
        ],
      ),
    );
  }
}
