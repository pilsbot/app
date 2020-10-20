import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roslib/roslib.dart';

final String serverAddress = 'http://192.168.178.39:5001/';
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
    ros = Ros(url: 'ws://192.168.178.39:9090');
  }
}

/// Always return a Map<String, dynamic> with AT LEAST {'error': bool} element
Future<Map<String, dynamic>> restPost(id, params) async {
  try {
    http.Response res = await http.post(
      serverAddress + id,
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
    http.Response res = await http.get(
      serverAddress + id,
      headers: headers,
    );
    Map<String, dynamic> returnVal = json.decode(res.body);
    returnVal['error'] = false;
    returnVal['statusCode'] = res.statusCode;
    return returnVal;
  } catch (_){ }
  return {'error': true};
}
