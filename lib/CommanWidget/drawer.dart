import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/IntroSliderPages/Logo.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/data/localSecureStorage/flutterStorageHelper.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/mobileRecharge.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/Notification.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/bankholidays.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/careandsupport.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/companyinformaction.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/distributorinformation.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/loginReport.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/profile.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/settings.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/share_apk_link.dart';
import 'package:myapp/ui/pages/languagePage.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/complaintPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

class MyDrawer extends StatefulWidget {
  final String firmname;

  const MyDrawer({Key key, this.firmname}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}
ScrollController scroll = ScrollController();

class _MyDrawerState extends State<MyDrawer> {

  String referlcode = "";
  String dpPicture = "";


  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState((){
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      }
      );
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    if(message == "Authorized"){

      final storage = new FlutterSecureStorage();
      var fingerauthenticate = await storage.read(key: "authenticate");

      if(fingerauthenticate == "true"){


        var flutterStorage = FlutterStorageHelper();
        flutterStorage.addNewItem('authenticate', "false");

        setState(() {
          fingeronoff = false;
        });

      }else{

        var flutterStorage = FlutterStorageHelper();
        flutterStorage.addNewItem('authenticate', "true");

        setState(() {
          fingeronoff = true;
        });

      }

    }else{

     Navigator.of(context).pop();
    }

    setState(() {
      _authorized = message;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refrcode();
    dpPhoto();
  }

  void refrcode()async{

    final prefs = await SharedPreferences.getInstance();
    referlcode  = prefs.getString("referlcode");

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    var fingerauthenticate = await storage.read(key: "authenticate");

    if(fingerauthenticate == "true"){

      setState(() {
        fingeronoff = true;
      });

    }else if(fingerauthenticate == null){

      setState(() {
        fingeronoff = false;
      });

    }else{
      setState(() {
        fingeronoff = false;
      });
    }

    setState(() {
      referlcode;
    });

  }

  bool fingeronoff = false;

  void dpPhoto()async{
    setState(() {
      blTest1 = true;
    });
    await Future.delayed(const Duration(seconds: 1), ()
    async {

      final prefs = await SharedPreferences.getInstance();
      dpPicture = prefs.getString('dpPhoto');
      setState(() {
        dpPicture;
      });
      blTest1 = false;
    });

  }
  bool blTest = false;
  bool blTest1 = false;

  @override
  Widget build(BuildContext context) {

    setState(() {
      if(widget.firmname== null){
        blTest=true;
      }
      else{
        blTest=false;
      }

    });

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
                                        referlcode == null ? Center(child: DoteLoaderWhiteColor()) :Text( referlcode,style: TextStyle(color: TextColor,fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 5)),

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
                                  MaterialPageRoute(builder: (_) => Profile())
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child:dpPicture == "" ? Stack(
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
                                            "https://test.vastwebindia.com/" + dpPicture,scale: 1),
                                      ),
                                    ),

                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          blTest ? DoteLoaderWhiteColor():Text(
                                            widget.firmname == null ? "":widget.firmname,
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
                        Divider(height: 1,),
                        Container(
                          color: PrimaryColor.withOpacity(0.8),
                          child: TextButton(
                            onPressed:()async{
                              _authenticateWithBiometrics();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.fingerprint,color: Colors.white,),
                                  SizedBox(width: 14,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("FINGERPRINT", overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 12),
                                      ),
                                      Text("Additional Security", overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 8),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: fingeronoff == true ? true : false,
                                    child: Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 20),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                                color: Colors.white,
                                                width: .5
                                            )

                                        ),
                                        child: Text("OFF",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    replacement: Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 20),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: .5
                                            )
                                        ),
                                        child: Text("ON",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                                      ),
                                    ),
                                  )


                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(height: 1,),
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
                            Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.notification_important_outlined,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Notifications'), overflow: TextOverflow.ellipsis,
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
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DistributorInformation()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.account_box,color: SecondaryColor,),
                                SizedBox(width: 14,),
                                Expanded(
                                  child: Text(getTranslated(context, 'Distributor'), overflow: TextOverflow.ellipsis,
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
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
