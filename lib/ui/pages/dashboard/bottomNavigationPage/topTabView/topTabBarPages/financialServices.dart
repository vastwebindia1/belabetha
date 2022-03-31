import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/CommanWidget/Servicepurchasepage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/Aadharpay.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/AepsEkyc.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/AepsEkycScan.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/Aepsmainpage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/Ministatement.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/aepscheckbalance.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/CashDeposite/cashDeposit.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/CheckbalancePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/Matmstatuscheck.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/MicroatmmainPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/Rgistervm30device.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/cashatposmainpage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/purchasemainpage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Pancard/PancardPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/UpiPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Pancard/Registeruser.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Towallet/WalletSender.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/UPI/Upisender.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/moneyTransfer.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/payDmt.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Towallet/toWallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HomePage.dart';
import 'RechargeAndBill.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FinancialServices extends StatefulWidget {
  @override
  _FinancialServicesState createState() => _FinancialServicesState();
}

class _FinancialServicesState extends State<FinancialServices> {

  Image image1;
  Image image2;
  Image image3;
  Image image4;
  Image image5;
  Image image6;
  Image image7;
  Image image8;
  Image image9;
  Image image10;
  Image image11;
  Image image12;
  Image image13;

  var devicesrn;
  String pagename,aepspag;
  String upiid = "";
  String minamnt = "1";
  String maxamnt = "10";

  Future<void> pancardstatus() async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/PAN/api/PAN/PancardStatusCheck");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["Response"];
      var msz = data["Message"];

      print(status);
      print(msz);

      if(status == "BOTHNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "PANCARD",)));

      }else if(status == "NOTOK"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "PANCARD",)));


      }else if (status == "ALLNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "PANCARD",)));


      }else if(status == "Registered"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => Pancardpage(psaid: msz,)));

      }else if(status == "NOTRegistered") {

        Navigator.push(context, MaterialPageRoute(builder: (_) => Registerpancard(status: status,)));

      }else if(status == "PENDING") {

        Navigator.push(context, MaterialPageRoute(builder: (_) => Registerpancard(status: status,)));

      }else{

          final snackBar2 = SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> vm30status() async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/MerchantCreateToSubmit");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {


    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["status"];
      var msz = data["msg"];


      if(status == "Success"){

        devicesrn = data["devicesr"];
        vm30activiation();

      }else if(status == "StatusCheck"){
        Navigator.push( context, MaterialPageRoute( builder: (context) => mAtmstatuscheck()), ).then((value) => setState(() {}));
       /*
        Navigator.push(context, MaterialPageRoute(builder: (_) => mAtmstatuscheck()));
*/
      }else if (status == "Device"){
        devicesrn = data["devicesr"];
        Navigator.push( context, MaterialPageRoute( builder: (context) => registervm30()), ).then((value) => setState(() {}));
       /*
        Navigator.push(context, MaterialPageRoute(builder: (_) => registervm30(deviceSerial: devicesrn,)));
*/

      }else if(status == "REGISTER"){

        regvmsts();

      }else if(status == "BOTHNOTDONE") {

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "VM30",)));

      }else if(status == "NOTOK"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "VM30",)));

      }else if(status == "ALLNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "VM30",)));

      }else{

        setState(() {
          final snackBar2 = SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        });

      }



    } else {
      throw Exception('Failed');
    }
  }

  Future<void> vm30activiation() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/ApiPassword");
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
      var isvalid = data["IsValidCustomer"];

      if(isvalid == true){

        if(pagename == "microatm"){

          Navigator.push(context, MaterialPageRoute(builder: (context) => MatmMainPage()));

        }else if(pagename == "cashpos"){

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CashatposPage()));

        }else if(pagename == "purchase"){

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Purchasemainpage()));

        }else if(pagename == "checkbalnce"){

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckbalancePage()));

        }

      }else{

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }




    } else {
      throw Exception('Failed');
    }
  }

  Future<void> regvmsts() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/ActiveMicroATM");
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
      var status = data["status"];
      var msz = data["msg"];

      if(status == "Success"){
        Navigator.push( context, MaterialPageRoute( builder: (context) => mAtmstatuscheck()), ).then((value) => setState(() {}));
/*
        Navigator.push(context, MaterialPageRoute(builder: (_) => mAtmstatuscheck()));
*/


      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> aepsstatuscheck() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/CheckEkyc");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var msz = dataa["Message"];

      if(status == true){

        aepsactiviation();


      }else if(msz == "REQUIREDOTP"){
        Navigator.push( context, MaterialPageRoute( builder: (context) => Aepsekyc()), ).then((value) => setState(() {}));

        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Aepsekyc()));*/

      }else if(msz == "REQUIREDSCAN"){
        Navigator.push( context, MaterialPageRoute( builder: (context) => Aepsekycscan()), ).then((value) => setState(() {}));

/*
        Navigator.push(context, MaterialPageRoute(builder: (context) => Aepsekycscan()));
*/


      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {
      throw Exception('Failed to load themes');
    }

  }

  Future<void> impsstatuscheck() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/DMTStatusCheck");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Response"];
      var msz = dataa["Message"];

      if(status == "Success"){

        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MoneyTransferPage()));

      }else if(status == "BOTHNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "DMT",)));

      } else if(status == "NOTOK"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "DMT",)));


      }else if (status == "ALLNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "DMT",)));


      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {
      throw Exception('Failed to load themes');
    }

  }

  Future<void> aepsactiviation() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/AepsStatusCheck");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Response"];
      var msz = dataa["Message"];

      if(status == "Success"){

        if(aepspag == "aepsmain"){

          Navigator.push(context, MaterialPageRoute(builder: (_) => Aepsmain()));

        }else if(aepspag == "aadhrpay"){

          Navigator.push(context, MaterialPageRoute(builder: (_) => Aadharpay()));

        }else if(aepspag == "minstm") {

          Navigator.push(context, MaterialPageRoute(builder: (_) => Ministatement()));

        }else if(aepspag == "chkblnc"){

          Navigator.push(context, MaterialPageRoute(builder: (_) => Aepscheckbalance()));

        }

      }else if(status == "BOTHNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "AEPS",)));


      }else if(status == "NOTOK"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "AEPS",)));

      }else if(status == "ALLNOTDONE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "AEPS",)));


      }else if(msz == "OTPREQUIRED"){


      }else if(msz == "PURCHASE"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => ServicepurchasePage(typename: "AEPS",)));

      }else {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }

    } else {
      throw Exception('Failed to load themes');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image1 = Image.asset('assets/pngImages/money-transfer.png', width: 10,);
    image2 = Image.asset('assets/pngImages/UPI.png', width: 32,);
    image3 = Image.asset('assets/pngImages/wallet2.png', width: 32,);
    image4 = Image.asset('assets/pngImages/cashDeposit.png', width: 32,);
    image5 = Image.asset('assets/pngImages/atm-machine.png', width: 32,);
    image6 = Image.asset('assets/pngImages/cashPos.png', width: 32,);
    image7 = Image.asset('assets/pngImages/Pos.png', width: 32,);
    image8 = Image.asset('assets/pngImages/Other-Pos.png', width: 32,);
    image9 = Image.asset('assets/pngImages/Aeps.png', width: 32,);
    image10 = Image.asset('assets/pngImages/Aadhaar-Pay.png', width: 32,);
    image11 = Image.asset('assets/pngImages/Mini-ststment.png', width: 32,);
    image12 = Image.asset('assets/pngImages/Check-Bal.png', width: 32,);
    image13 = Image.asset('assets/pngImages/pancard.png', width: 32,);
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.red[900],
    content: Text('You are not Authorized..',style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
  );

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
    precacheImage(image5.image, context);
    precacheImage(image6.image, context);
    precacheImage(image7.image, context);
    precacheImage(image8.image, context);
    precacheImage(image9.image, context);
    precacheImage(image10.image, context);
    precacheImage(image11.image, context);
    precacheImage(image12.image, context);
    precacheImage(image13.image, context);

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PrimaryColor,
      child: Container(
        decoration: BoxDecoration(
        ),
        margin: EdgeInsets.only(left: 8,right: 8,top: 0),
        child: Column(
          children: [
            /*Money Transfer================*/
            Container(
              margin: EdgeInsets.only(left: 8,right: 8,top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: TextColor,
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                color: DashboardCardPrimaryColor.withOpacity(0.9),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 5,top: 6,bottom: 6),
                                child: Text(
                                  getTranslated(context, 'Money Transfer Services'),
                                  style: TextStyle(fontSize: 12,color: DashboardCardTextColor),)))
                      ],
                    ),
                    Row(
                      children: [

                        Expanded(
                          child: IconButtonInk1(
                            onPressed: () {

                              impsstatuscheck();
                              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => MoneyTransferPage()));*/
                            },
                            icon:image1,
                            colors: Colors.white,
                            text:getTranslated(context, 'To Account'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: () {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => UpisenderPage()));

                            },
                            icon:image2,
                            colors: Colors.white,
                            text:getTranslated(context, 'To UPI'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (_) => walletsenderpage()));

                            },
                            icon:image3,
                            colors: Colors.white,
                            text:getTranslated(context, 'To Wallet'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){

                              Navigator.push(context, MaterialPageRoute(builder: (_) => CashDeposit()));

                            },
                            icon:image4,
                            colors: Colors.white,
                            text:getTranslated(context, 'Cash Deposit') ,
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3,),
                  ],
                ),
              ),
            ),
            /*Pos & Aadhaar Services================*/
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: TextColor,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                color: DashboardCardPrimaryColor.withOpacity(0.9),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 5,top: 6,bottom: 6),
                                child: Text(
                                  getTranslated(context, 'Pos & Aadhaar Services'),
                                  style: TextStyle(fontSize: 12,color: DashboardCardTextColor),)))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){
                              setState(() {
                                pagename = "microatm";
                              });
                              vm30status();


                            },
                            icon:image5,
                            colors: Colors.white,
                            text:getTranslated(context, 'Micro ATM'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){

                              setState(() {
                                pagename = "cashpos";
                              });
                              vm30status();

                            },
                            icon:image6,
                            colors: Colors.white,
                            text:getTranslated(context, 'CashPos'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){
                              setState(() {
                                pagename = "purchase";
                              });
                              vm30status();

                            },
                            icon:image7,
                            colors: Colors.white,
                            text:getTranslated(context, 'Purchase'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){

                              setState(() {
                                pagename = "checkbalnce";
                              });
                              vm30status();

                            },
                            icon:image8,
                            colors: Colors.white,
                            text:getTranslated(context, 'Check Balance'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3,),
                    Row(
                      children: [
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){
                              setState(() {
                                aepspag = "aepsmain";
                              });
                              aepsstatuscheck();
                            },
                            icon:image9,
                            colors: Colors.white,
                            text:getTranslated(context, 'Aeps'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){
                              setState(() {
                                aepspag = "aadhrpay";
                              });
                              aepsstatuscheck();
                            },
                            icon:image10,
                            colors: Colors.white,
                            text:getTranslated(context, 'Aadhaar Pay'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){

                              setState(() {
                                aepspag = "minstm";
                              });

                              aepsstatuscheck();
                            },
                            icon:image11,
                            colors: Colors.white,
                            text:getTranslated(context, 'Mini Statement'),
                            textStyle:
                            TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                        Expanded(
                          child: IconButtonInk1(
                            onPressed: (){
                              setState(() {
                                aepspag = "chkblnc";
                              });
                              aepsstatuscheck();
                            },
                            icon:image12,
                            colors: Colors.white,
                            text:getTranslated(context, 'Check Balance'),
                            textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 8,right: 8,top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: TextColor,
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                color:DashboardCardPrimaryColor.withOpacity(0.9),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 5,top: 6,bottom: 6),
                                child: Text(
                                  getTranslated(context, 'Other services'),
                                  style: TextStyle(fontSize: 12,color: DashboardCardTextColor),)))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:IconButtonInk1(
                            onPressed: () async {

                              pancardstatus();

                            },
                            icon:image13,
                            colors: Colors.white,
                            text:getTranslated(context, 'Pan Card'),
                            textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                          ),

                        ),
                        Expanded(child: Container()),
                        Expanded(child: Container()),
                        Expanded(child: Container()),

                      ],
                    ),
                    SizedBox(height: 3,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
