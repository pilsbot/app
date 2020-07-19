import 'package:http/http.dart' as http;
import 'dart:convert';

final String serverAddress = 'http://192.168.178.38:5001/';
final int serverTimeout = 2; // sec
final Map<String,String> headers = {
  'Content-type' : 'application/json',
  'Accept': 'application/json',
};

Future<bool> restPost(id, params) async {
  try {
    http.Response res = await http.post(
      serverAddress + id,
      headers: headers,
      body: json.encode(params),
    );
    if(res.statusCode == 200){
      return true;
    }
    return false;
  } catch (_){ }
  return false;
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
