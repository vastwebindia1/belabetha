import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;

class MasterToken extends StatefulWidget {
  const MasterToken({Key key}) : super(key: key);
  @override
  _MasterTokenState createState() => _MasterTokenState();
}
class _MasterTokenState extends State<MasterToken> {
  String remainToken= "";
  List  dealer = [];
  String userid = "";
  String retailerName = "Select Dealer Name";
  String retailerId = "";
  String retailerFirm = "";
  String retailerAmount = "";
  ScrollController listSlide = ScrollController();
  TextEditingController _textController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  Future<void> masteruserdetails() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var data = dataa["data"];
      remainToken = data["creationtoken"].toString();

      setState(() {

        remainToken;

      });

    } else {
      throw Exception('Failed to load themes');
    }

  }

  Future<void> masterPurchaseToken(String dealer1,String delTok,) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/master/addJoiningToken_dlm",{
      "ddlDealer":dealer1,
      "tokenCount":delTok,
    });


    http.Response response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },

    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var  status = data["success"];


      if (status == "Token Debited Successfully.") {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: status,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MasterManinDashboard()));
          },
        );      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: status,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
            });
            Navigator.of(context).pop();
          },
        );
      }
    } else {

      throw Exception('Failed');
    }
  }

  void retailerListdialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color:PrimaryColor,
                        padding: EdgeInsets.only(top: 8,),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8,left: 8,right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(getTranslated(context, 'Select Dealer'),
                                  style: TextStyle(color: TextColor,fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {

                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon:Icon(Icons.search,color: TextColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                          ),
                          style: TextStyle(color: TextColor,fontSize: 20),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(// Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: dealer.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.transparent) ,
                                        shadowColor: MaterialStateProperty.all(Colors.transparent),
                                        backgroundColor:MaterialStateProperty.all(Colors.transparent) ,
                                        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          retailerName = dealer[index]["Name"];
                                          retailerFirm = dealer[index]["firmName"];
                                          retailerId = dealer[index]["UserID"].toString();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(getTranslated(context, 'Name')+ " :" +dealer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Text( getTranslated(context, 'FirmName') +" : " +dealer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (dealer[index]["Name"]
                                .toLowerCase()
                                .contains(_textController.text) || dealer[index]["Name"]
                                .toUpperCase()
                                .contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              retailerName = dealer[index]["Name"];
                                              retailerFirm = dealer[index]["firmName"];
                                              retailerId = dealer[index]["UserID"].toString();
                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text( getTranslated(context, 'Name') +dealer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text( getTranslated(context, 'FirmName') +dealer[index]["firmName"].toString().toUpperCase() ,textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                              );
                            }
                          },
                        ),),
                    )
                ),
              ),
            );
          });
        });
  }

  Future<void> dealerList(String master) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/master/distibutorlist",{
      "masterid" :master,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });
    });

    print(response);
    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);
      setState(() {
        dealer = dataa1;});
    } else {
      throw Exception('Failed to load themes');
    }
  }
  void masterid() async{
    final storage = new FlutterSecureStorage();
    var b = await storage.read(key: "userId");
    userid = b;
    setState(() {
      dealerList(userid);
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    masterid();
    masteruserdetails();
   /* dealerList(userid);*/
    tokenReport();
  }


  List tokenList = [];


  Future<void> tokenReport() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/master/Remain_dealer_token_report");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);


      setState(() {

        tokenList = dataa;

      });

    } else {
      throw Exception('Failed to load themes');
    }

  }

  ScrollController listScroll = ScrollController();
  TextStyle tabTextStyle= TextStyle(fontSize: 14,color: TextColor);
  TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: TextColor);
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: TextColor, fontSize: 16);
    TextStyle labelStyle = TextStyle(
      color: PrimaryColor,
      fontSize: 14,
    );
    Color color = PrimaryColor;
    return AppBarWidget(
      title: LeftAppBar(
        topText: getTranslated(context, 'Purchase Use Token'),
        selectedItemName: getTranslated(context, 'Now Remain'),
        sellName: remainToken.toString(),
      ),
      body: SingleChildScrollView(
        child: StickyHeader(
            header: Container(
              child: Column(
                children: [
                  Container(
                    height: 45,
                    margin: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      clipBehavior: Clip.none,
                      autofocus: false,
                      color:Colors.transparent ,
                      highlightColor:Colors.transparent ,
                      highlightedBorderColor: PrimaryColor,
                      focusColor:PrimaryColor ,
                      padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                      borderSide: BorderSide(width: 1,color: PrimaryColor),
                      onPressed: retailerListdialog,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(child: Text(retailerName,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 16),)),
                            SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.none,
                    height: 45,
                    margin: EdgeInsets.only(
                        left: 10, right: 5, top: 5, bottom: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        Container(
                          child: Expanded(
                            child: TextFormField(
                              controller: tokenController,
                              maxLength: 10,
                              buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: SecondaryColor),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: SecondaryColor),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: SecondaryColor),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: SecondaryColor),
                                  borderRadius: BorderRadius.circular(0),),
                                contentPadding: EdgeInsets.only(left: 10, right: 16,),
                                hintText: getTranslated(context, 'Enter Token'),
                                labelStyle: labelStyle,
                                fillColor:TextColor,
                                hintStyle: labelStyle,
                              ),
                              style: TextStyle(
                                color: PrimaryColor,
                                fontSize: 16,
                              ),

                            ),
                          ),
                        ),
                        Container(
                            transform: Matrix4.translationValues(-2.0, 0.0, 0.0),
                            width: 130,
                            margin: EdgeInsets.only(
                              right: 3,
                            ),
                            decoration: BoxDecoration(
                              border:
                              Border(top: BorderSide(width: 1, color: PrimaryColor),
                                bottom: BorderSide(width: 1, color: PrimaryColor),
                                right: BorderSide(width: 1, color: PrimaryColor),),
                              color: SecondaryColor,
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                          width: 0,
                                          color: Colors.transparent)),
                                ),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.zero),
                              ),
                              child: Text(
                                    getTranslated(context, 'Sale Token'),
                                    style: TextStyle(color: TextColor),
                                  ),
                              onPressed: () {
                                setState(() {
                                  masterPurchaseToken(retailerId,tokenController.text);
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Container(
                      color: PrimaryColor,
                      padding: EdgeInsets.only(bottom: 0,top: 0),
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.only(left: 0,right: 0,top: 0),
                        padding: EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 2,),
                                    Text(
                                      getTranslated(context, 'Token Report'),
                                      style: tabTextStyle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                color: TextColor,
                child: tokenList.length == 0 ? Container(
                    child: Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 16),)) : Container(
                      child: FutureBuilder(
                          builder: (context, projectSnap) {
                            if (projectSnap.connectionState ==
                                ConnectionState.none &&
                                projectSnap.hasData == null) {
                              //print('project snapshot data is: ${projectSnap.data}');
                              return Container();
                            }
                            return  ListView.builder(
                      controller: listScroll,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: tokenList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title:Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: PrimaryColor.withOpacity(0.08),
                                      blurRadius: .5,
                                      spreadRadius: 1,
                                      offset:
                                      Offset(.0, .0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                margin:
                                EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 0),
                                padding: EdgeInsets.all(1.0),

                                child: Container(
                                  color:Colors.white.withOpacity(0.5),
                                  padding: EdgeInsets.all(4),

                                  child: Column(
                                    children: [

                                      Container(
                                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),


                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0),

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 37,
                                                        width: 37,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: SecondaryColor,
                                                            ),
                                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                                            color: TextColor
                                                        ),
                                                        child: Text(tokenList[index]["RemainTokenPost"].toString(),
                                                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: 4),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                getTranslated(context, 'TOKEN'),
                                                                softWrap: true,
                                                                style: TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              SizedBox(height: 1,),
                                                              Text(
                                                                getTranslated(context, 'QTY'),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2,
                                                height: 28,
                                                child: Container(
                                                  width: 2,
                                                  color: Colors.black12,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Text(getTranslated(context, 'Dealer Name'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                      SizedBox(height: 1,),
                                                      Text(tokenList[index]["DealerName"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2,
                                                height: 25,
                                                child: Container(
                                                  width: 2,
                                                  color: Colors.black12,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(getTranslated(context, 'FirmName'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                      SizedBox(height: 1,),
                                                      Text(tokenList[index]["FarmName"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.left,)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      

                                    ],
                                  ),
                                ),


                              ),
                              onTap: (){
                                /*Navigator.push(context, MaterialPageRoute(builder: (context) =>RetailerDetail()));*/
                              },
                            ),

                          ],

                        );

                      });
                    },
                          future: tokenReport(),
                    )
                    ),
              ),
            ),
        ),
      ),
    );
  }
}
