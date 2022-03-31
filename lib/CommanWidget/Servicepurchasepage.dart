import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ServicepurchasePage extends StatefulWidget {
  ServicepurchasePage({Key key, this.typename}) : super(key: key);
  final String typename;
  @override
  _ServicepurchasePageState createState() => _ServicepurchasePageState();
}

class _ServicepurchasePageState extends State<ServicepurchasePage> {

  bool _isloading = false;
  bool visivle1 = true;
  bool visivle2 = false;

  String paymtype = "";
  String price = "";

  String typee;

  Future<void> Servicecharge(String type) async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/ServiceCharge",{

      "Service":type,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
       paymtype = data["PaymentType"].toString();
       price = data["Price"].toString();

       setState(() {
         paymtype;
       });



    } else {
      throw Exception('Failed');
    }
  }

  Future<void> Servicepurchase(String type) async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/ServicePurchase",{

      "Service":type,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      _isloading = false;
      var data = json.decode(response.body);
      var status = data["Status"];
      var msz = data["Message"];

     if(status == "Success"){


       CoolAlert.show(
         backgroundColor: PrimaryColor.withOpacity(0.7),
         context: context,
         type: CoolAlertType.success,
         text: msz,
         title: status,
         confirmBtnText: 'OK',
         confirmBtnColor: Colors.green,
         onConfirmBtnTap: (){
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));},

       );




     }else{

       CoolAlert.show(
         backgroundColor: PrimaryColor.withOpacity(0.6),
         context: context,
         type: CoolAlertType.error,
         text: msz,
         title: status,
         confirmBtnText: 'OK',
         confirmBtnColor: Colors.red,
         onConfirmBtnTap: (){
           Navigator.of(context).pop();},
       );

     }



    } else {
      throw Exception('Failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
        title: CenterAppbarTitleImage(
          svgImage: 'assets/pngImages/pancard.png',
          topText: "ALl",
          selectedItemName: "Services Purchase",
        ),
        body: Scaffold(
          backgroundColor: TextColor,
          body: Container(
            child: SafeArea(
              child: Column(
                children: [

                  Visibility(
                     visible: visivle1,
                     child: Column(
                     children: [
                     Container(
                       margin: EdgeInsets.only(top: 40),
                       child: Center(
                         child:  Image.asset('assets/pngImages/warningg.png',height: 100,width: 100,),
                       ),
                     ),
                     SizedBox(
                       height: 10,
                     ),
                     Container(
                       child: Text("Your Service is Expaired",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 16),),
                     ),
                     SizedBox(
                       height: 10,
                     ),
                     Container(
                         margin: EdgeInsets.only(left: 10,right: 10),
                         child: Text("Your service is currently down, if you want to keep the service running smoothly, you will have to pay the service fee, which you see below and you can purchase the service by clicking the button.",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.justify)
                     ),
                     SizedBox(
                       height: 10,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                             margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                             decoration: BoxDecoration(
                               borderRadius: const BorderRadius.all(
                                 const Radius.circular(5.0),
                               ),
                             ),
                             child:
                             Row(


                                 children: [
                                   Container(
                                   width: 150,
                                   child: OutlinedButton(
                                   style: OutlinedButton.styleFrom(
                                     padding: EdgeInsets.all(15),
                                     backgroundColor:SecondaryColor ,
                                     shadowColor:Colors.transparent,

                                   ),
                                   onPressed:(){

                                     setState(() {
                                       visivle1 = false;
                                       visivle2 = true;
                                       typee = "ALL";
                                     });
                                     Servicecharge("ALL");
                                   },
                                   child: Text("ALL Services",style: TextStyle(color: TextColor),),
                                 ),
                               ),
                             ])),
                             Container(
                             margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                             decoration: BoxDecoration(
                               borderRadius: const BorderRadius.all(
                                 const Radius.circular(5.0),
                               ),
                             ),
                             child:
                             Row(children: [
                               Container(
                                 width: 150,
                                 child: OutlinedButton(
                                   style: OutlinedButton.styleFrom(
                                     padding: EdgeInsets.all(15),
                                     backgroundColor:SecondaryColor ,
                                     shadowColor:Colors.transparent,

                                   ),
                                   onPressed:(){

                                     setState(() {
                                       visivle1 = false;
                                       visivle2 = true;
                                       typee = widget.typename;
                                     });
                                     Servicecharge(widget.typename);
                                   },
                                   child: Text(widget.typename,style: TextStyle(color: TextColor),),
                                 ),
                               ),
                             ]))
                       ],
                     )
                   ],
                 )),

                  Visibility(
                    visible: visivle2,
                      child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50),
                        child: Text("Service Payment",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: SecondaryColor),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(child: Text("Mode",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: SecondaryColor),),),
                            Container(child: Text(paymtype,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: PrimaryColor)))

                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(child: Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: SecondaryColor),),),
                            Container(child: Text(price,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: PrimaryColor)))

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      MainButtonSecodn(
                          onPressed:() async{
                            setState(() {
                              _isloading = true;
                            });
                            Servicepurchase(typee);
                          },
                          color: SecondaryColor,
                          btnText:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Expanded(
                              child: _isloading ? Center(child: SizedBox(
                                height: 20,
                                child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                              ),) : Text(getTranslated(context, 'Pay'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                          ),
                        ],
                      )
                      ),
                    ],
                  ))

                ],
              )
            ),
          ),
        )
    );
  }
}
