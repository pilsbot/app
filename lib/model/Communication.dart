import 'package:http/http.dart' as http;
import 'dart:convert';

final String serverAddress = 'http://192.168.178.38:5001/';
final int serverTimeout = 2; // sec
final Map<String,String> headers = {
  'Content-type' : 'application/json',
  'Accept': 'application/json',
};

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
