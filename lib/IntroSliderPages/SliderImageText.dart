import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



var status;
var data;
String images1 = "https://www.aashadigitalindia.co.in//Retailer_image//6588f74a-f633-4c90-a14d-ae282fe04242.jpg";
String images2 = "https://cdn.pixabay.com/photo/2019/02/15/11/04/book-3998252_960_720.jpg";

Future<void> imageslider() async {


  String token = "";
  var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/appdataslider");
  final http.Response response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print(response);

  if (response.statusCode == 200) {
    var dataa = json.decode(response.body);
    status = dataa['status'];
    data   = dataa['data'];

    images1 = data[0]["sliderimages"].toString();
    images2 = images1.replaceAll('\\', '//');


  } else {

    throw Exception('Failed');
  }


}



final images = [
  images1,
  images2,
  'assets/images/background.png',
  'assets/images/planting.png',
];

final message = [
  "dfdsfsd",
  "fdsfsdf",
  "dfdfdsfds",
  "fdsfdfdsfd"
];


final controller = PageController();
var numberOfPages = 4;
int currentPage = 0;



