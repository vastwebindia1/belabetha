import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/addMoney.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/paymentOptions.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;





class VideoKyc extends StatefulWidget {
  @override
  _VideoKycState createState() => _VideoKycState();
}
int selectedIndex = 0;
class _VideoKycState extends State<VideoKyc> {
  File _image;
  File _cameraImage;
  File _video;
  File _cameraVideo;

  String Role = "Retailer";
  String userId;
  String video641;
  String playbtn = "Play Video";
  bool includeAudio;
  String english1,hindi1;

  bool pausebtnvis = false;
  bool playbtnvis  = true;

  bool _isloading = false;
  bool _isloading3 = false;
  bool _isloading2 = false;
  bool _obscureText = true;

  bool playvide = false;


  bool threbtn = false;
  bool strtbtn = true;
  bool logout = true;
  bool backcontent = false;

  bool lodervisi = false;

  bool hindiRow = true;
  bool englishRow = false;
  String name;

  Future<void> userIdenty() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "userId");

    String userid = a;
    setState(() {
      userId = userid;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  ImagePicker picker = ImagePicker();

  VideoPlayerController _videoPlayerController;
  VideoPlayerController _cameraVideoPlayerController;

  // This funcion will helps you to pick a Video File from Camera
  _pickVideoFromCamera() async {


    PickedFile pickedFile = await picker.getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 38));



    try{
      _cameraVideo = File(pickedFile.path);
    }catch(e){

      setState(() {
        content = true;
        logout = true;
        backcontent = false;
        strtbtn = true;
        threbtn = false;
        vidosecc = false;
        _isloading2 = false;
        _isloading = false;
      });
    }




    MediaInfo mediaInfo = await VideoCompress.compressVideo(
      pickedFile.path,
      quality: VideoQuality.LowQuality,
      includeAudio: true,
      deleteOrigin: false,
    );

    MediaInfo mediaInfo1 = await VideoCompress.compressVideo(
      mediaInfo.path,
      quality: VideoQuality.LowQuality,
      includeAudio: true,
      deleteOrigin: false,
    );

    MediaInfo mediaInfo2 = await VideoCompress.compressVideo(
      mediaInfo1.path,
      quality: VideoQuality.LowQuality,
      includeAudio: true,
      deleteOrigin: false,
    );

    final bytes = Io.File(mediaInfo2.path).readAsBytesSync();

    video641 = base64Encode(bytes);

    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
      ..initialize().then((_) {
        setState(() {
          vidosecc = true;
          _isloading2 = false;
          _isloading = false;
          logout = false;
          strtbtn = false;

          threbtn = true;
          backcontent = true;
        });
        _cameraVideoPlayerController.pause();

      });

    _cameraVideoPlayerController.setLooping(true);
  }

  bool firstTap = false;
  bool secondTap = true;
  bool vidosecc = true;
  String hindi = "";
  String eng = "";
  String next = "red";
  bool content = true;

  void changeLay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        englishRow = true;
        hindiRow = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        hindiRow = true;
        englishRow = false;

        selectedIndex = 1;
      });
    }
  }

  TextStyle tabTextStyle= TextStyle(fontSize: 14,color: Colors.black);
  TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: Colors.black);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIdenty();
    uploadVideoContent();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _cameraVideoPlayerController.dispose();
    super.dispose();
  }

  Future<void> uploadVideo(String user, String roll, String video) async {


    var url = new Uri.http("test.vastwebindia.com", "/api/user/UploadKYCVIDEO");

    Map map = {
      "userids": user,
      "role": roll,
      "kycvideo": video,
    };

    String body = json.encode(map);

    try{

      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: body).timeout(Duration(seconds: 30), onTimeout: () {

        setState(() {
          _isloading3 = false;
        });
      });;

      print(response);

      if (response.statusCode == 200) {
        _isloading3 = false;

        var dataa = json.decode(response.body);

        var sts = dataa["status"];
        var msz = dataa["msg"];

        if (sts == "Success") {

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.7),
            context: context,
            type: CoolAlertType.success,
            text: "video upload SuccessFully",
            title: sts,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));},

          );
        }else{


          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            title: sts,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();},
          );

        }
      } else {
        _isloading3 = false;
        throw Exception('Failed');
      }


    }catch(e){

      uploadVideo2(userId,Role,video641);

    }
  }

  Future<void> uploadVideo2(String user, String roll, String video) async {


    var url = new Uri.https("www.test.vastwebindia.com", "/api/user/UploadKYCVIDEO");

    Map map = {
      "userids": user,
      "role": roll,
      "kycvideo": video,
    };

    String body = json.encode(map);

    try{

      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: body).timeout(Duration(seconds: 30), onTimeout: () {

        setState(() {
          _isloading3 = false;
        });
      });;

      print(response);

      if (response.statusCode == 200) {
        _isloading3 = false;

        var dataa = json.decode(response.body);

        var sts = dataa["status"];
        var msz = dataa["msg"];

        if (sts == "Success") {

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.7),
            context: context,
            type: CoolAlertType.success,
            text: "video upload SuccessFully",
            title: sts,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));},

          );
        }else{


          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            title: sts,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();},
          );

        }
      } else {
        _isloading3 = false;
        throw Exception('Failed');
      }


    }catch(e){

      print(e);

    }
  }

  Future<void> uploadVideoContent() async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/Show_Video_KYC_Content");
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
      hindi = dataa["hindi"];
      eng = dataa["english"];
      name = dataa["remname"];

      setState(() {
        hindi;
      });


    } else {
      throw Exception('Failed to load themes');
    }


  }

  DateTime backbuttonpressedTime;

  final snackBar2 = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Double Click to exit app',textAlign: TextAlign.center,style: TextStyle(color: Colors.yellowAccent),),
      ],
    ),
  );

  Future<bool> _onbackpress() async {

    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      // ignore: unnecessary_statements
      SnackBar;
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      return false;
    }

    final storage = new FlutterSecureStorage();
    storage.deleteAll();

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Material(
        child:SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15,left: 10,right: 10,),
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(children: <InlineSpan>[
                              TextSpan(
                                  text: 'Hi ${name} Please Complete Your Video KYC',
                                  style: TextStyle(color: TextColor,fontSize: 16,)),
                              TextSpan(
                                  text: ' Now !',
                                  style: TextStyle(
                                    color: SecondaryColor,fontSize: 16,)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Visibility(
                                visible: content,
                                child: Column(

                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),

                                      decoration: BoxDecoration(
                                        color: PrimaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text('View Recording Information With Both Language ',
                                              style: TextStyle(fontSize: 14,color: TextColor,),
                                            ),
                                          ),


                                        ],
                                      ),

                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                          right: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                // border: Border.all(
                                                //   color:secondTap ? Colors.black: Colors.black,
                                                // ),
                                                borderRadius: BorderRadius.all(Radius.circular(0)),
                                                color:firstTap ? PrimaryColor.withOpacity(0.1): PrimaryColor.withOpacity(0.1),
                                              ),
                                              child: FlatButton(
                                                shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  changeLay(2);
                                                },
                                                child:secondTap ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.check_circle,size: 18,color: Colors.green,),
                                                    SizedBox(width: 2,),
                                                    Text(
                                                      "Hindi".toUpperCase(),
                                                      style: tabTextStyle2,
                                                    ),
                                                  ],
                                                ): Text("Hindi".toUpperCase(),
                                                  style: tabTextStyle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4,),
                                          Expanded(
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                // border: Border.all(
                                                //   color:firstTap ? Colors.white: Colors.white,
                                                // ),
                                                borderRadius: BorderRadius.all(Radius.circular(0)),
                                                color: secondTap ? PrimaryColor.withOpacity(0.1): PrimaryColor.withOpacity(0.1),
                                              ),
                                              child: FlatButton(
                                                shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  changeLay(1);
                                                },
                                                child:firstTap ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.check_circle,size: 14,color: Colors.green,),
                                                    SizedBox(width: 2,),
                                                    Text(
                                                      "English".toUpperCase(),
                                                      style: tabTextStyle2,
                                                    ),
                                                  ],
                                                ):Text(
                                                  "English".toUpperCase(),
                                                  style: tabTextStyle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: englishRow,

                                      child: Row (
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              height: 200,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                                  left: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                                  right: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                                ),
                                              ),
                                              child:SingleChildScrollView(
                                                child: Text(eng,
                                                  style: TextStyle(fontSize: 20),),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: hindiRow,
                                      child: Row (
                                        children: [
                                          Expanded(
                                            child: Container(
                                                padding: const EdgeInsets.all(8.0),
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                                    left: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                                    right: BorderSide(width: 2, color: PrimaryColor.withOpacity(0.2)),
                                                  ),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Text(hindi,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),

                              if (_cameraVideo != null)_cameraVideoPlayerController.value.initialized ?
                              Visibility(
                                  visible: vidosecc,
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    width: 340,
                                    height: 400,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(width: 5, color: PrimaryColor),
                                        right: BorderSide(width: 5, color: PrimaryColor),
                                        top: BorderSide(width: 5, color: PrimaryColor),
                                      ),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: _cameraVideoPlayerController.value.aspectRatio ,
                                      child: VideoPlayer(_cameraVideoPlayerController),
                                    ),
                                  ))
                                  : Container(),


                              Row(
                                children: [
                                  Expanded(
                                    child:_isloading2 ? Container(
                                      margin: EdgeInsets.only(top: 100),
                                      child: Center(
                                          child: Column(
                                            children: [
                                              CollectionScaleTransition(
                                                children: <Widget>[
                                                  Icon(Icons.circle, size: 15, color: SecondaryColor,),
                                                  Icon(Icons.circle, size: 15, color: SecondaryColor),
                                                  Icon(Icons.circle, size: 15, color: SecondaryColor),
                                                  Icon(Icons.circle, size: 15, color: SecondaryColor),

                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text("Please Wait...",style: TextStyle(fontSize: 24,color: PrimaryColor,fontWeight: FontWeight.bold),),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text("Do not refresh the page Your file is",style: TextStyle(fontSize: 20,color: SecondaryColor,),),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("currently in compressed mode.",style: TextStyle(fontSize: 20,color: SecondaryColor,),),
                                            ],
                                          )
                                      ),
                                    ) :
                                    Visibility(
                                      visible: strtbtn,
                                      child:FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                          padding: EdgeInsets.all(9),
                                          color: SecondaryColor,
                                          onPressed: () {
                                            setState(() {
                                              vidosecc = false;
                                              content = false;
                                              logout = false;
                                              _isloading2 = true;
                                            });
                                            _pickVideoFromCamera();
                                          },
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.photo_camera_front,size:35,color: TextColor,),
                                              SizedBox(width: 5,),
                                              Text("Start Now",style: TextStyle(color: TextColor,fontSize: 30,),),
                                            ],
                                          )

                                      ),
                                    ),
                                  ),


                                  SizedBox(width: 5,),

                                  Visibility(
                                    visible: logout,
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.all(10),
                                          backgroundColor:PrimaryColor ,
                                          shadowColor:Colors.transparent,
                                        ),
                                        onPressed: (){
                                          final storage = new FlutterSecureStorage();
                                          storage.deleteAll();
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) => LoginPage()));

                                        },
                                        child: Icon(Icons.power_settings_new_outlined,color: TextColor,size: 33,)

                                    ),
                                  ),
                                ],
                              ),

                              Visibility(
                                visible: threbtn,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 0,top: 5,),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 5, color: PrimaryColor),
                                      right: BorderSide(width: 5, color: PrimaryColor),
                                      bottom: BorderSide(width: 5, color: PrimaryColor),
                                    ),
                                    color: PrimaryColor,
                                  ),
                                  child: Row(
                                    children: [

                                      Visibility(
                                        visible: playbtnvis,
                                        child: Expanded(
                                          child: FlatButton(
                                              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                              padding: EdgeInsets.all(0),
                                              color: TextColor,
                                              onPressed: () {

                                                setState(() {
                                                  pausebtnvis = true;
                                                  playbtnvis = false;

                                                });

                                                _cameraVideoPlayerController.play();

                                              },
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.play_arrow_outlined,size:20,color: Colors.black,),
                                                  SizedBox(width: 2,),
                                                  Text("Play Video".toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 11),)
                                                ],
                                              )

                                          ),
                                        ),),

                                      Visibility(
                                        visible: pausebtnvis,
                                        child: Expanded(
                                          child: FlatButton(
                                              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                              padding: EdgeInsets.all(0),
                                              color: TextColor,
                                              onPressed: () {

                                                setState(() {

                                                  pausebtnvis = false;
                                                  playbtnvis = true;

                                                });

                                                _cameraVideoPlayerController.pause();

                                              },
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.pause,size:20,color: Colors.black,),
                                                  SizedBox(width: 2,),
                                                  Text("Pause Video".toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 11),)
                                                ],
                                              )

                                          ),
                                        ),),

                                      SizedBox(width: 5,),

                                      Expanded(
                                        child: FlatButton(
                                            shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                            padding: EdgeInsets.all(0),
                                            color: TextColor,
                                            onPressed: () {
                                              setState(() {
                                                _isloading = true;
                                              });
                                              _cameraVideoPlayerController.pause();
                                              _pickVideoFromCamera();
                                            },
                                            child: _isloading
                                                ? Center(child: SizedBox(
                                              height: 15,
                                              width: 80,
                                              child: LinearProgressIndicator(backgroundColor: SecondaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                            ),)
                                                :Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.replay,size: 18,color: Colors.black,),
                                                SizedBox(width: 2,),
                                                Text("Make Again".toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 11,),),
                                              ],
                                            )

                                        ),
                                      ),

                                      SizedBox(width: 5,),

                                      Expanded(
                                        child: FlatButton(
                                            shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                            padding: EdgeInsets.all(0),
                                            color: TextColor,
                                            onPressed: () {
                                              setState(() {
                                                _isloading3 = true;
                                              });
                                              _cameraVideoPlayerController.pause();
                                              uploadVideo(userId,Role,video641);
                                            },
                                            child:_isloading3
                                                ? Center(child: SizedBox(
                                              height: 15,
                                              width: 80,
                                              child: LinearProgressIndicator(backgroundColor: SecondaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                            ),)
                                                :Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.upload_outlined,size: 20,color: Colors.black,),
                                                SizedBox(width: 2,),
                                                Text("Upload Video".toUpperCase(),style: TextStyle(color: Colors.black,fontSize: 11,),),
                                              ],
                                            )

                                        ),
                                      ),

                                    ],

                                  ),
                                ),),

                              SizedBox(height: 10,),
                              Visibility(
                                visible: backcontent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                          padding: EdgeInsets.all(0),
                                          color: TextColor,
                                          onPressed: () {
                                            setState(() {
                                              content = true;
                                              logout = true;
                                              backcontent = false;
                                              strtbtn = true;
                                              threbtn = false;
                                              vidosecc = false;
                                            });
                                          },
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.arrow_back,
                                                size: 20,
                                                color: SecondaryColor,
                                              ),
                                              Text("Back",style: TextStyle(color: SecondaryColor),)
                                            ],
                                          )

                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    ), onWillPop: _onbackpress);
  }

}

