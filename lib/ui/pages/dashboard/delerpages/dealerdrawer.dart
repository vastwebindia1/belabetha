import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/dealerProfile.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/masterInfo.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/bankholidays.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/careandsupport.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/companyinformaction.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/loginReport.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/settings.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/share_apk_link.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/complaintPage.dart';
import '../../languagePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

class MyDrawerDealer extends StatefulWidget {
  final String firmname;

  const MyDrawerDealer({Key key, this.firmname}) : super(key: key);

  @override
  _MyDrawerDealerState createState() => _MyDrawerDealerState();
}
ScrollController scroll = ScrollController();

class _MyDrawerDealerState extends State<MyDrawerDealer> {

  String dealerReferlcode = "";
  String dealerDpPicture = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refrcode();
    dealerDpPhoto();
  }

  void refrcode()async{

    final prefs = await SharedPreferences.getInstance();
    dealerReferlcode = prefs.getString("referlcode");
    setState(() {
      dealerReferlcode;


    });

  }


  void dealerDpPhoto()async{
    setState(() {
      blTest1 = true;
    });
    await Future.delayed(const Duration(seconds: 1), ()
    async {

      final prefs = await SharedPreferences.getInstance();
      dealerDpPicture = prefs.getString('dealerDpPhoto');
      setState(() {
        dealerDpPicture;
      });
      blTest1 = false;
    });

  }
  bool blTest = false;
  bool blTest1 = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: TextColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StickyHeader(
                  overlapHeaders: false,
                  header:Container(
                    color: TextColor,
                    child: Column(
                      children: [
                        Container(
                          color: SecondaryColor.withOpacity(0.9),
                          child: Container(
                            padding: EdgeInsets.only(top: 8,bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: SecondaryColor,
                                border: Border.all(width: 2,color: TextColor),
                              ),
                              margin: EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                                children: [
                                  Container(color: TextColor,width: 5,height: 33,margin: EdgeInsets.only(),),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(right: 10),
                                    width: 35,
                                    height: 33,
                                    color: TextColor,
                                    child: Icon(Icons.confirmation_num_sharp,color: SecondaryColor,size: 30,),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(margin: EdgeInsets.only(left: 5),child: Text(getTranslated(context, 'Referral Karo'),style: TextStyle(color: TextColor,fontSize: 9.75),)),
                                        Text( "referlcode",style: TextStyle(color: TextColor,fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 5)),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 4,right: 4,top:0,bottom: 0 ),
                          color: PrimaryColor.withOpacity(0.8),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),

                            ),
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => DealerProfile())
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:dealerDpPicture == "" ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child:Image(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              color: TextColor,
                                              image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png",),
                                            ),
                                          ),

                                        ]
                                    ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:blTest1 ? SizedBox(
                                          height:30,width: 30,child: CircularProgressIndicator(color: SecondaryColor,)):Image(
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "https://test.vastwebindia.com/" + dealerDpPicture,scale: 1),
                                      ),
                                    ),

                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.firmname.toUpperCase(),
                                            style: TextStyle(
                                                color: TextColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,maxLines: 1,
                                          ),
                                          SizedBox(height: 5,),
                                          Container(
                                            child: Text(
                                              "Aasha Digital India",
                                              style: TextStyle(
                                                color: TextColor,fontSize: 12,
                                              ),overflow: TextOverflow.ellipsis,
                                              softWrap: false,maxLines: 1,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Icon(Icons.arrow_forward_ios_outlined,size: 18,color: TextColor,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) ,
                  content:Container(
                    child: Column(
                      children: [

                        TextButton(
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CareAndSupport()));

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.support_agent,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Care & Support'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),

                        Divider(height: 1,),

                        TextButton(
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Complaint()));

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.comment_outlined,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Complain Chat'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => BankHolidays()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.today_sharp,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Bank Holidays'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed:(){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ShareApkLink())
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.share,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Share Apk Link'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CompanyInformation()));

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.apartment,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Company Info'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => MasterInfo()));

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.account_box,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Master Info'),
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => LanguageChange()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.local_library_sharp,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'App Language'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AppSettings()));

                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.miscellaneous_services,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Login Setting'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => LoginInformation()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.location_history,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Login History'),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1,),
                        TextButton(
                          onPressed:()async {
                            final storage = new FlutterSecureStorage();
                            storage.deleteAll();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.power_settings_new,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Logout APP'), overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor,fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,color: PrimaryColor,),
                              ],
                            ),
                          ),
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
    );
  }
}
