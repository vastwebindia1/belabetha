import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myapp/IntroSliderPages/SlidePage.dart';
import 'package:myapp/ThemeColor/Color.dart';

class fullfromnews extends StatefulWidget {
  const fullfromnews({Key key}) : super(key: key);

  @override
  _fullfromnewsState createState() => _fullfromnewsState();
}

class _fullfromnewsState extends State<fullfromnews> {



  List newss = [];
  ScrollController _scrollController = new ScrollController();

  Future<void> userdetails() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);

      setState(() {
        newss = dataa["newservices"];
      });
    } else {
      throw Exception('Failed to load themes');
    }

  }

  List imagelist = [];
  Uint8List image1;

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
       var data   = dataa['data'];


       for(int i =0; i<data.length; i++){

          var images = data[i]["Imagesss"];
          image1 = base64.decode(images);
          imagelist.add(image1);
       }

       print(imagelist);

       setState(() {
         imagelist;
       });



     /* if(data.length == 0){

        setState(() {
          //imgee = "null";
        });

      }else{

        var img1 = data[0]["Imagesss"];
        var img2 = data[1]["Imagesss"];
        var img3 = data[2]["Imagesss"];
        var img4 = data[3]["Imagesss"];

        var  image1 = base64.decode(img1);
        image2 = base64.decode(img2);
        image3 = base64.decode(img3);
        image4 = base64.decode(img4);

      }*/



    } else {
      throw Exception('Failed');
    }


  }

  bool viewVisible = true;
  bool viewVisible1 = false;

  List imglit = [
    'assets/Sl10.png',
    'assets/Sl4.png',
    'assets/SL02.png',
    'assets/SL3.png'
  ];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdetails();
    imageslider();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15,bottom: 15,),
                decoration: BoxDecoration(
                  color:PrimaryColor.withOpacity(0.9),),
                  child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        child: Container(
                          child: Container(
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: TextColor,
                                                ),
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(100),
                                                ),
                                                color: TextColor
                                            ),
                                            child:Icon(Icons.notification_important,size: 80,)
                                          ),
                                          SizedBox(height: 5,),
                                          Text("Alerts & Notifiactions",style: TextStyle(color: TextColor,fontSize: 18,),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child:IconButton(
                                    onPressed:(){
                                     Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.arrow_back,color: SecondaryColor,),

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {

                          setState(() {
                            viewVisible = true;
                            viewVisible1 = false;
                          });
                          
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            top: viewVisible ? 7 : 6,
                            bottom: viewVisible ? 7 : 6,
                            right: viewVisible ? 18 : 5,
                            left: viewVisible ? 18 : 5,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: SecondaryColor,), borderRadius: BorderRadius.all(Radius.circular(50))),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(viewVisible ? Icons.check_circle : Icons.check_circle,color:SecondaryColor, size: viewVisible ? 19 : 0,),
                              SizedBox(
                                width: viewVisible ? 5 : 0,
                              ),
                              Container(
                                child: Text("News",
                                  style: TextStyle(
                                      fontWeight: viewVisible
                                          ? FontWeight.bold
                                          : viewVisible1
                                          ? FontWeight.normal
                                          : FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                      onTap: () {
                        setState(() {
                          viewVisible = false;
                          viewVisible1 = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: viewVisible ? 7 : 6,
                          bottom: viewVisible ? 7 : 6,
                          right: viewVisible ? 18 : 5,
                          left: viewVisible ? 18 : 5,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: SecondaryColor,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(50))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              viewVisible1 ? Icons.check_circle : Icons.check_circle,color:SecondaryColor, size: viewVisible1 ? 19 : 0,
                            ),
                            SizedBox(
                              width: viewVisible1 ? 5 : 0,
                            ),
                            Container(
                              child: Text(
                                "Image Slider",
                                style: TextStyle(fontWeight: viewVisible1 ? FontWeight.bold : viewVisible ? FontWeight.normal : FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              viewVisible ? Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: newss.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: new EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: new BoxDecoration(
                                    color: SecondaryColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(3)
                                      ),
                                      child:Image.network(newss[index]["images"],height: 64,width: 64,),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 8,right: 3),
                                        child:Text(newss[index]["messahes"],overflow: TextOverflow.clip,textAlign: TextAlign.justify,),
                                      ),),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          )
                      );
                    }),
              ) : Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: imagelist == null ? imglit.length :imagelist.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                margin: new EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: new BoxDecoration(
                                    color: SecondaryColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3)
                                  ),
                                  child:imagelist == null ? Image.asset(imglit[index],fit: BoxFit.fill,) :Image.memory(imagelist[index],fit: BoxFit.fill,),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          )
                      );
                    }),
              )
            ],
          )

        ),
      ),
    );
  }
}
