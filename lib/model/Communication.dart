import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roslib/roslib.dart';
import 'package:global_configuration/global_configuration.dart';

final int serverTimeout = 2; // sec
final Map<String,String> headers = {
  'Content-type' : 'application/json',
  'Accept': 'application/json',
};

class RosCom
{
  static final _rosCom = RosCom._internal();
  Ros ros;

  factory RosCom() {
    return _rosCom;
  }

  RosCom._internal()
  {
    ros = Ros(url: "ws://0.0.0.0:9090", verbose: false);
  }
}

/// Always return a Map<String, dynamic> with AT LEAST {'error': bool} element
Future<Map<String, dynamic>> restPost(id, params) async {
  try {
    await GlobalConfiguration().loadFromAsset("config");
    String ip = GlobalConfiguration().getValue("server_ip");
    String port = GlobalConfiguration().getValue("server_port_rest");
    http.Response res = await http.post(
      ip+':'+port+'/'+id,
      headers: headers,
      body: json.encode(params),
    );
    Map<String, dynamic> returnVal = json.decode(res.body);
    returnVal['error'] = false;
    returnVal['statusCode'] = res.statusCode;
    return returnVal;
  } catch (_){ }
  return {'error': true};
}

Future<Map<String, dynamic>> restGet(id) async{
  try {
    await GlobalConfiguration().loadFromAsset("config");
    String ip = GlobalConfiguration().getValue("server_ip");
    String port = GlobalConfiguration().getValue("server_port_rest");
    http.Response res = await http.get(
      ip+':'+port+'/'+id,
      headers: headers,
    );
    Map<String, dynamic> returnVal = json.decode(res.body);
    returnVal['error'] = false;
    returnVal['statusCode'] = res.statusCode;
    return returnVal;
  } catch (_){ }
  return {'error': true};
}
