import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myapp/data/localSecureStorage/flutterStorageHelper.dart';
import './AppExceptions.dart';

class ApiBaseHelper {
  String accessToken = '';
 ApiBaseHelper(){
  //accessToken =  FlutterStorageHelper().read('accessToken') as String;
 
 } 
final String _baseUrl = "api.vastwebindia.com";
  
Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.https(_baseUrl, url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
}

Future<dynamic> post(String url, Map<dynamic, dynamic> headers, Map<dynamic, dynamic> httpBody) async {
    var responseJson;
    try {
      final response = await http.post(Uri.http(_baseUrl, url), headers:{"Accept": "*/*", "Authorization": 'bearer'+ accessToken}, body: httpBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
  
}
}