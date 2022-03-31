import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/DealerDashboard.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../dashboard.dart';
import 'dart:io' as Io;

class DealerProfile extends StatefulWidget {
  const DealerProfile({Key key}) : super(key: key);

  @override
  _DealerProfileState createState() => _DealerProfileState();
}

class _DealerProfileState extends State<DealerProfile> {
  bool editbtnup = true;
  bool savebtnup = false;
  bool editbtn = true;
  bool savebtn = false;
  bool editbtn2 = true;
  bool savebtn2 = false;
  TextEditingController JoindateController = TextEditingController();
  TextEditingController FirmnameController = TextEditingController();
  TextEditingController NameController = TextEditingController();
  TextEditingController DobController = TextEditingController();
  TextEditingController MobileController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PositionController = TextEditingController();
  TextEditingController BusinessController = TextEditingController();
  TextEditingController AadhaarController = TextEditingController();
  TextEditingController PenController = TextEditingController();
  TextEditingController GstController = TextEditingController();
  TextEditingController BusinessaddressController = TextEditingController();
  TextEditingController StateController = TextEditingController();
  TextEditingController DisctrictController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController PinController = TextEditingController();

  String userid1 = "";
  String name1 = "";
  String firmName1 = "";
  String mobile1 = "";
  String pinCode1 = "";
  String email1 = "";
  String address1 = "";
  String district1 = "";
  String districtId1 = "";
  String state1 = "";
  String stateId1 = "";
  String cityName1 = "";
  String aadharNumber1 = "";
  String panNumber1 = "";
  String gstNumber1 = "";
  String status1 = "";
  String moneyStatus1 = "";
  String accountNumber1 = "";
  String accHolder1 = "";
  String accIfsc1 = "";
  String bankname1 = "";
  String bankAddress1 = "";
  String joinDate1 = "";
  String dobDate1 = "";
  String panPath1 = "";
  String aadharFrontPath1 = "";
  String aadharBackPath1 = "";
  String registerPath1 = "";
  String agreementPath1 = "";
  String selfieShop1 = "";
  String gstCertificatePath1 = "";
  String retailerPhoto1 = "";
  String checkAadharFrontPath1 = "";
  String checkAadharbackpath1 = "";
  String checkPanPath1 = "";
  String checkSelfieShop1 = "";

  String checkRegisterPath1 = "";
  String checkServiceAgrementPath1 = "";
  String aadharStatus1 = "";
  String panStatus1 = "";
  String selfieShopStatus1 = "";
  String businessType1 = "";
  String businessTypeCode1 = "";
  String serviceAgreeStatus1 = "";

  String pinNumber1 = "1234";
  String password1 = "123456";

  String dateNow = "";
  String dobNow = "";

  /*File  _image;
  File _cameraImage;*/
  String aadharFront = "";
  String aadharBack = "";
  String pan = "";

  String uploadType = "";
  String viewType = "";
  bool isloading = false;
  String roll1 = "";
  String dialogName = "Upload Aadhar Front Pic";

  String userID1 = "";


  Future<void> userID() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "userId");
    var b = await storage.read(key: "role");

    String userid2 = a;
    String roll = b;
    setState(() {
      userID1 = userid2;
      roll1 = roll;

      setState(() {

        dealerRemProfile(userID1);


      });

    });
  }

  Future<void> dealerRemProfile(String dealerid) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/dealer_profile", {
      "dlmid": dealerid,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data2 = json.decode(response.body);

      userid1 = data2["UserID"];
      name1 = data2["Name"];
      firmName1 = data2["firmName"];
      mobile1 = data2["Mobile"];
      pinCode1 = data2["PIN"];
      email1 = data2["Email"];
      address1 = data2["Address"];
      district1 = data2["District"];
      districtId1 = data2["DistrictID"].toString();
      state1 = data2["State"];
      stateId1 = data2["StateID"].toString();
      cityName1 = data2["Cityname"];
      aadharNumber1 = data2["Aadhar"];
      panNumber1 = data2["PAN"];
      gstNumber1 = data2["GST"];
      status1 = data2["Status"];
      moneyStatus1 = data2["MoneySts"].toString();
      accountNumber1 = data2["Bankaccountno"];
      accHolder1 = data2["accountholder"];
      accIfsc1 = data2["Ifsccode"];
      bankname1 = data2["bankname"];
      bankAddress1 = data2["bankAddress"];
      joinDate1 = data2["JoinDate"];
      dobDate1 = data2["dob"];
      checkRegisterPath1 = data2["chkRegistractioncertificatepath"].toString();
      checkServiceAgrementPath1 = data2["chkserviceagreementpath"].toString();
      checkPanPath1 = data2["chkpanpath"].toString();
      checkAadharFrontPath1 = data2["chkaadharfront"].toString();
      checkAadharbackpath1 = data2["chkaadharback"].toString();
      checkSelfieShop1 = data2["chkShopwithSalfie"].toString();
      aadharStatus1 = data2["aadharsts"];
      panStatus1 = data2["PSAStatus"];
      retailerPhoto1 = data2["Photo"].toString();
      panPath1 = data2["pancardPath"].toString();
      aadharBackPath1 = data2["aadharcardBacksidePath"].toString();
      aadharFrontPath1 = data2["aadharcardPath"].toString();
      selfieShop1 = data2["ShopwithSalfie"].toString();
      selfieShopStatus1 = data2["ShopwithSalfieStatus"];
      serviceAgreeStatus1 = data2["Iserviceagreementtatus"].toString();
      businessType1 = data2["BusinessType"];
      businessTypeCode1 = data2["BusinessTypeCode"];

      DateTime dateJoin = DateTime.parse(joinDate1);
      dateNow = DateFormat.yMd().format(dateJoin);

      final prefs = await SharedPreferences.getInstance();

      prefs.setString("name", name1);
      prefs.setString("email", email1);
      prefs.setString("mobi", mobile1);

      /* DateTime dobJoin = DateTime.parse(dobDate1);
      dobNow = DateFormat.yMd().format(dobJoin);*/

      setState(() {
        checkAadharFrontPath1;
        JoindateController.text = joinDate1;
        FirmnameController.text = firmName1;
        NameController.text = name1;
        MobileController.text = mobile1;
        DobController.text = dobDate1;
        EmailController.text = email1;
        PositionController.text = businessType1;
        BusinessController.text = businessTypeCode1;
        AadhaarController.text = aadharNumber1;
        PenController.text = panNumber1;
        GstController.text = gstNumber1;
        BusinessaddressController.text = address1;
        StateController.text = state1;
        DisctrictController.text = district1;
        CityController.text = cityName1;
        PinController.text = pinCode1;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> dealerProfileUpload1(
      String name3,
      String mobile3,
      String dob3,
      String email3,
      String position3,
      String business3,
      String aadhar3,
      String pan3,
      String gst3,
      String firm3,
      String address3,
      String pincode3 ,
      String districtId3,
      String StateId3,
      String pin3,
      String password3,
      String joinDate3,
      String cityName3) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url =
    new Uri.http("api.vastwebindia.com", "/api/data/UpdateDealerProfile");

    Map map = {
      "Name": name3,
      "firmName": firm3,
      "Mobile": mobile3,
      "PINCode": pincode3,
      "Email": email3,
      "Address": address3,
      "District": districtId3,
      "State": StateId3,
      "Aadhar": aadhar3,
      "PAN": pan3,
      "GST": gst3,
      "dob": dob3,
      "BusinessType": position3,
      "BusinessTypeCode": business3,
      "Password": password3,
      "PIN": pin3,
      "JoinDate": joinDate3,
      "Cityname": cityName3,
    };

    String body = json.encode(map);

    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["Response"];
      var msz = data["Message"];

      if (status == "Success") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
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
    userID();
    statelist();
  }

  final aadharFrontGalleryPicker = ImagePicker();

  _pickImageFromGallery() async {
    PickedFile pickedFile = await aadharFrontGalleryPicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    /* File image = File(pickedFile.path);*/

    final bytes2 = Io.File(pickedFile.path).readAsBytesSync();

    aadharFront = base64Encode(bytes2);

    setState(() {
      dialogName = "Upload aadhar Back Pic";
      uploadAadhardialog();
    });
  }

  final aadharFrontCameraPicker = ImagePicker();

  _pickImageFromCamera() async {
    PickedFile pickedFile = await aadharFrontCameraPicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    /*File image = File(pickedFile.path);*/

    final bytes1 = Io.File(pickedFile.path).readAsBytesSync();

    aadharFront = base64Encode(bytes1);

    setState(() {
      dialogName = "Upload aadhar Back Pic";
      uploadAadhardialog();
    });
  }

  final aadharBackGalleryPicker = ImagePicker();

  _pickImageFromGallery2() async {
    PickedFile pickedFile = await aadharBackGalleryPicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    /* File image = File(pickedFile.path);*/

    final bytes2 = Io.File(pickedFile.path).readAsBytesSync();

    aadharBack = base64Encode(bytes2);

    setState(() {
      uploadAadhar(aadharFront, aadharBack, userid1, roll1);
      Navigator.of(context).pop();
    });
  }

  final aadharBackCameraPicker = ImagePicker();

  _pickImageFromCamera2() async {
    PickedFile pickedFile = await aadharBackCameraPicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    /*File image = File(pickedFile.path);*/

    final bytes1 = Io.File(pickedFile.path).readAsBytesSync();

    aadharBack = base64Encode(bytes1);

    setState(() {
      uploadAadhar(aadharFront, aadharBack, userid1, roll1);
      Navigator.of(context).pop();
    });
  }

  final panGalleryPicker = ImagePicker();

  _pickImageFromGallery3() async {
    PickedFile pickedFile = await panGalleryPicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    /* File image = File(pickedFile.path);*/

    final bytes2 = Io.File(pickedFile.path).readAsBytesSync();

    pan = base64Encode(bytes2);

    setState(() {
      if (uploadType == "upload PanCard Pic") {
        uploadPan(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "Selfie Upload") {
        uploadShopSelfie(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "Select Picture") {
        uploadDisplayPic(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "upload Gst Certificate") {
        uploadGstCertificate(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "Service Agreement") {
        uploadServiceAgreement(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else {}
    });
  }

  final panCamerapicker = ImagePicker();

  _pickImageFromCamera3() async {
    PickedFile pickedFile = await panCamerapicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    /*File image = File(pickedFile.path);*/

    final bytes1 = Io.File(pickedFile.path).readAsBytesSync();

    pan = base64Encode(bytes1);

    setState(() {
      if (uploadType == "upload PanCard Pic") {
        uploadPan(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "Selfie Upload") {
        uploadShopSelfie(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "Select Picture") {
        uploadDisplayPic(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "upload Gst Certificate") {
        uploadGstCertificate(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else if (uploadType == "Service Agreement") {
        uploadServiceAgreement(pan, userid1, roll1);
        Navigator.of(context).pop();
      } else {}
    });
  }

  List statesList;
  List districtlist;
  String _myState;
  String _mydis;

  Future<void> statelist() async {
    String token = "";

    var url =
    new Uri.http("api.vastwebindia.com", "/Common/api/data/statelist");
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

      setState(() {
        statesList = dataa;
      });
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> distrilist(String code) async {
    String token = "";

    var url1 =
    new Uri.http("api.vastwebindia.com", "/Common/api/data/districtList", {
      "stateid": code,
    });
    final http.Response response = await http.get(
      url1,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);

      setState(() {
        districtlist = dataa;
      });
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> uploadAadhar(String front, String back, String id, String roll) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.https(
        "test.vastwebindia.com", "/api/user/UploadDocumentsImages");
    Map map = {
      "AadharcardFront": front,
      "AadharcardBack": back,
      "txtretailerid": id,
      "currentrole": roll,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);

      var sts = dataa["Message"];

      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> uploadPan(String pan1, String id, String roll) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.https(
        "test.vastwebindia.com", "/api/user/UploadDocumentsImages");
    Map map = {
      "PancardFront": pan1,
      "txtretailerid": id,
      "currentrole": roll,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);

      var sts = dataa["Message"];

      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> uploadGstCertificate(String pan1, String id, String roll) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.https(
        "test.vastwebindia.com", "/api/user/UploadDocumentsImages");
    Map map = {
      "Registrationcertificatepath": pan1,
      "txtretailerid": id,
      "currentrole": roll,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);

      var sts = dataa["Message"];

      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> uploadShopSelfie(String selfie, String id, String roll) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.https(
        "test.vastwebindia.com", "/api/user/UploadDocumentsImages");
    Map map = {
      "ShopeWithSelfie": selfie,
      "txtretailerid": id,
      "currentrole": roll,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);
      var sts = dataa["Message"];

      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> uploadServiceAgreement(String pan1, String id, String roll) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.https(
        "test.vastwebindia.com", "/api/user/UploadDocumentsImages");
    Map map = {
      "Serviceaggreementpath": pan1,
      "txtretailerid": id,
      "currentrole": roll,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);

      var sts = dataa["Message"];

      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> uploadDisplayPic(String image, String id, String roll) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.https("test.vastwebindia.com", "/api/user/UploadUserImages");
    Map map = {
      "ProfileImagess": image,
      "txtretailerid": id,
      "currentrole": roll,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body);
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);

      var sts = dataa["Message"];

      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DealerProfile()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  void uploadAadhardialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.only(left: 10, right: 10, top: 10),
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 15,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: SecondaryColor,
                        size: 20,
                      ),
                      Text(
                        dialogName.toUpperCase(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 25,
                    width: 25,
                    child: FlatButton(
                      color: PrimaryColor.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: PrimaryColor,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: new BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(0),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.clear,
                        color: TextColor,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: FlatButton(
                          color: TextColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: SecondaryColor.withOpacity(0.8),
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          onPressed: () {
                            setState(() {
                              if (dialogName == "Upload aadhar Back Pic") {
                                _pickImageFromGallery2();
                              } else {
                                _pickImageFromGallery();
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.insert_photo_outlined,
                                color: SecondaryColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                getTranslated(context, 'Upload From Gallery'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: FlatButton(
                          color: TextColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: SecondaryColor.withOpacity(0.8),
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          onPressed: () {
                            setState(() {
                              if (dialogName == "Upload aadhar Back Pic") {
                                _pickImageFromCamera2();
                              } else {
                                _pickImageFromCamera();
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: SecondaryColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                getTranslated(context, 'Upload From Camera'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -0.5,
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
            ),
          );
        });
  }

  void viewAadhardialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.only(left: 0, right: 0, top: 0),
              contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0,),
              title: Container(
                color: PrimaryColor.withOpacity(0.8),
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.image_rounded,
                          color: SecondaryColor,
                          size: 20,
                        ),
                        Text(
                          getTranslated(context, 'Image'),
                          style: TextStyle(fontSize: 18, color: TextColor),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 25,
                      width: 25,
                      child: FlatButton(
                        color: PrimaryColor.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: PrimaryColor,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(0),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.clear,
                          color: TextColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: Container(
                height: 470,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 0,
                  bottom: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 5),
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 5, color: PrimaryColor)),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(context, 'Front Side'),
                                  style: TextStyle(
                                      fontSize: 16, color: SecondaryColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image(
                                width: 290,
                                height: 170,
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://test.vastwebindia.com/" +
                                        checkAadharFrontPath1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 5, color: PrimaryColor)),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(context, 'Back Side'),
                                  style: TextStyle(
                                      fontSize: 16, color: SecondaryColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image(
                                width: 290,
                                height: 170,
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://test.vastwebindia.com/" +
                                        checkAadharbackpath1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void uploaddialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.only(left: 0, right: 0, top: 0),
              contentPadding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 15,
              ),
              title: Container(
                color: PrimaryColor.withOpacity(0.8),
                padding: EdgeInsets.only(
                  top: 7,
                  bottom: 7,
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: SecondaryColor,
                          size: 20,
                        ),
                        Text(
                          uploadType.toUpperCase() == getTranslated(context, 'upload PanCard Pic')
                              ? getTranslated(context, 'Upload pan Card')
                              : uploadType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            color: TextColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 25,
                      width: 25,
                      child: FlatButton(
                        color: PrimaryColor.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: PrimaryColor,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(0),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.clear,
                          color: TextColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: FlatButton(
                          color: TextColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: SecondaryColor.withOpacity(0.8),
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          onPressed: () {
                            setState(() {
                              _pickImageFromGallery3();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.insert_photo_outlined,
                                color: SecondaryColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                getTranslated(context, 'Upload From Gallery'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: FlatButton(
                          color: TextColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: SecondaryColor.withOpacity(0.8),
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(0),
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          onPressed: () {
                            setState(() {
                              _pickImageFromCamera3();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: SecondaryColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                getTranslated(context, 'Upload From Camera'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -0.5,
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
            ),
          );
        });
  }

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();


  void viewdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.only(left: 0, right: 0, top: 0),
              contentPadding: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
              ),
              title: Container(
                color: PrimaryColor.withOpacity(0.8),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.image_rounded,
                          color: SecondaryColor,
                          size: 20,
                        ),
                        Text(
                          viewType == getTranslated(context, 'View panCard pic')
                              ? getTranslated(context, 'View PanCard')
                              : viewType,
                          style: TextStyle(fontSize: 18, color: TextColor),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 25,
                      width: 25,
                      child: FlatButton(
                        color: PrimaryColor.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: PrimaryColor,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(0),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.clear,
                          color: TextColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: Container(
                height: 250,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 5, color: PrimaryColor)),
                      child: viewType == getTranslated(context, 'View panCard pic')
                          ? Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://test.vastwebindia.com/" +
                                checkPanPath1),
                      )
                          : viewType == getTranslated(context, 'Selfie View')
                          ? Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://test.vastwebindia.com/" +
                                checkSelfieShop1),
                      )
                          : viewType == getTranslated(context, 'View Gst pic')
                          ? Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://test.vastwebindia.com/" +
                                checkRegisterPath1),
                      )
                          : viewType == getTranslated(context, 'View Service Agreement')
                          ? Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://test.vastwebindia.com/" +
                                checkServiceAgrementPath1),
                      )
                          : Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://www.planetware.com/wpimages/2020/02/france-in-pictures-beautiful-places-to-photograph-eiffel-tower.jpg"),
                      ),
                    ),
                    /* Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated(context, 'Back Side'),
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,letterSpacing: -0.5,),
                                ),

                              ],
                            ),

                          ),
                          Container(
                            width: 300,
                            height: 150,
                            padding: EdgeInsets.only(top: 5,),
                            child: Image(
                                image: AssetImage('assets/firstbg.jpg',),
                                fit: BoxFit.cover
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          );
        });
  }

  void statedialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee) {
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color: PrimaryColor,
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getTranslated(context, 'Select Your State'),
                                style: TextStyle(
                                    color: TextColor, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              CloseButton(color: SecondaryColor,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {});
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon: Icon(
                              Icons.search,
                              color: TextColor,
                            ),
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(width: 1, color: TextColor)),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(width: 1, color: TextColor)),
                            focusedBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(width: 1, color: TextColor)),
                          ),
                          style: TextStyle(color: TextColor, fontSize: 20),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                  // Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: statesList.length,
                          itemBuilder: (context, index) {
                            if (_textController.text.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                            shadowColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              state = statesList[index]
                                              ["State Name"];
                                              _myState = statesList[index]["Sate Id"].toString();
                                              distrilist(_myState);
                                              Navigator.of(context).pop();

                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              statesList[index]["State Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else if (statesList[index]["State Name"]
                                .toLowerCase()
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
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              state = statesList[index]
                                              ["State Name"];
                                            });
                                            _myState = statesList[index]["Sate Id"].toString();
                                            distrilist(_myState);

                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              statesList[index]["State Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )),
              ),
            );
          });
        });
  }

  void districtdialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee) {
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color: PrimaryColor,
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getTranslated(context, 'Select Your district'),
                                style: TextStyle(
                                  color: TextColor,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              CloseButton(color: SecondaryColor,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {});
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon: Icon(
                              Icons.search,
                              color: TextColor,
                            ),
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(width: 1, color: TextColor)),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(width: 1, color: TextColor)),
                            focusedBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(width: 1, color: TextColor)),
                          ),
                          style: TextStyle(
                            color: TextColor,
                            fontSize: 18,
                          ),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                  // Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: districtlist.length,
                          itemBuilder: (context, index) {
                            if (_textController.text.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                            shadowColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              district = districtlist[index]
                                              ["Dist Name"];
                                              _mydis = districtlist[index]
                                              ["Dist Id"].toString();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              districtlist[index]["Dist Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else if (districtlist[index]["Dist Name"]
                                .toLowerCase()
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
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              district = districtlist[index]
                                              ["Dist Name"];
                                              _mydis = districtlist[index]
                                              ["Dist Id"].toString();
                                              _textController.clear();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              districtlist[index]["Dist Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )),
              ),
            );
          });
        });
  }

  String state = "Select State";
  String district = "Select District";


  Future<bool> backbtn() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: SafeArea(
      child: Scaffold(
        backgroundColor: TextColor,
        body: SingleChildScrollView(

          child: Column(
            children: [
              Visibility(
                visible: editbtnup,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10,top: 7,bottom: 7),
                  decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(0.9),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_business,
                                        size: 16,
                                        color: TextColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        getTranslated(context, 'Business Name'),
                                        style: TextStyle(
                                            fontSize: 14, color: TextColor),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 0, bottom: 0),
                                    child:firmName1== null ? Container(
                                        margin: EdgeInsets.only(top: 3),
                                        child: DoteLoaderWhiteColor()):Text(firmName1,
                                      style:
                                      TextStyle(fontSize: 20, color: TextColor,fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 33,
                                            width: 33,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: PrimaryColor,
                                              borderRadius: BorderRadius.circular(50),

                                            ),
                                            padding: EdgeInsets.only(left: 0,right: 0,),
                                            margin: EdgeInsets.only(right: 4,),
                                            child: IconButton(
                                              onPressed: () => Navigator.pop(context),
                                              icon: Icon(
                                                Icons.arrow_back,
                                                size: 18,
                                                color: SecondaryColor,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 33,
                                            width: 33,
                                            margin: EdgeInsets.only(right: 4,),
                                            child: FlatButton(
                                                color: PrimaryColor,
                                                shape:RoundedRectangleBorder(side: BorderSide(color: PrimaryColor, width: 1, style: BorderStyle.solid),
                                                  borderRadius: new BorderRadius.circular(50),),
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  setState(() {
                                                    editbtn = false;
                                                    savebtn = true;
                                                  });
                                                },
                                                child: Icon(Icons.edit_outlined,color: SecondaryColor,size: 18,)
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 20,right: 20,top: 2,bottom: 2),
                                            decoration: BoxDecoration(
                                              color: PrimaryColor,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.date_range_sharp,color: SecondaryColor,size: 9,),
                                                    SizedBox(width: 4,),
                                                    Container(
                                                      padding: EdgeInsets.only(top: 2),
                                                      child: Text(getTranslated(context, 'JOINING DATE'),
                                                        style:
                                                        TextStyle(fontSize: 9, color: SecondaryColor,fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(top: 0, bottom: 0),
                                                      child:dateNow== null  ? DoteLoader(): Text(dateNow,
                                                        style:
                                                        TextStyle(fontSize: 12, color: SecondaryColor,fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(0),
                                    child:retailerPhoto1 == "null" ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child:Image(
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                              color: TextColor,
                                              image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png",),
                                            ),
                                          ),
                                          Positioned(
                                            right: 2,
                                            top: 2,
                                            child:  Container(
                                              height: 20,
                                              width: 20,
                                              child: FlatButton(
                                                color: TextColor,
                                                shape:RoundedRectangleBorder(side: BorderSide(color: TextColor, width: 1, style: BorderStyle.solid),
                                                  borderRadius: new BorderRadius.circular(50),),
                                                padding: EdgeInsets.all(0),
                                                child: Icon(Icons.camera_alt_rounded,size: 12,color: SecondaryColor,),
                                                onPressed: (){
                                                  setState(() {
                                                    uploadType = "Select Picture";
                                                  });
                                                  uploaddialog();{}
                                                },
                                              ),
                                            ),
                                          )
                                        ]
                                    ):Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child:Image(
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                              image: NetworkImage("https://test.vastwebindia.com/" + retailerPhoto1),
                                            ),
                                          ),
                                          Positioned(
                                            right: 2,
                                            top: 2,
                                            child:  Container(
                                              height: 20,
                                              width: 20,
                                              child: FlatButton(
                                                color: TextColor,
                                                shape:RoundedRectangleBorder(side: BorderSide(color: TextColor, width: 1, style: BorderStyle.solid),
                                                  borderRadius: new BorderRadius.circular(50),),
                                                padding: EdgeInsets.all(0),
                                                child: Icon(Icons.camera_alt_rounded,size: 12,color: SecondaryColor,),
                                                onPressed: (){
                                                  setState(() {
                                                    uploadType = "Select Picture";
                                                  });
                                                  uploaddialog();{}
                                                },
                                              ),
                                            ),
                                          )
                                        ]
                                    ),

                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),


              Visibility(
                visible: editbtn,
                child:Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: PrimaryColor.withOpacity(0.08),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: Offset(.0, .0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                    child: Container(
                      color: TextColor.withOpacity(0.5),
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.5),
                                      width: 3,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Container(
                                      width: MediaQuery.of(context).size.width/1.6,
                                      child: Text(
                                        getTranslated(context, 'Personal Info'),
                                        style: TextStyle(
                                            fontSize: 20, color: SecondaryColor),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    Container(
                                      height: 27,
                                      width: 27,
                                      margin: EdgeInsets.only(top: 2),
                                      child: FlatButton(
                                        color: SecondaryColor,
                                        shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            editbtn = false;
                                            savebtn = true;
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 14,
                                          color: TextColor,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Name'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      getTranslated(context, 'Date of Birth'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child:name1== null  ? DoteLoader():  Text(name1,
                                        style: TextStyle(
                                            fontSize: 14,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),

                                    Expanded(
                                      child:dobDate1 == null ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          DoteLoader(),
                                        ],
                                      ):  Text(dobDate1,style: TextStyle(
                                          fontSize: 14,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Mobile No'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      getTranslated(context, 'Email Id'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: mobile1== null  ? DoteLoader(): Text(mobile1,
                                        style: TextStyle(
                                            fontSize: 14,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Expanded(
                                      child:email1== null  ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          DoteLoader(),
                                        ],
                                      ):  Text(email1,
                                        style: TextStyle(
                                            fontSize: 14,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Position'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      getTranslated(context, 'Business Type'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child:businessType1== null  ? DoteLoader():  Text(businessType1,
                                        style: TextStyle(
                                            fontSize: 14,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    Expanded(
                                      child:businessTypeCode1== null  ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          DoteLoader(),
                                        ],
                                      ):  Text(businessTypeCode1,
                                        style: TextStyle(
                                            fontSize: 14,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            aadharStatus1 == "Y" ? Icon(Icons.check_circle,color: Colors.green,size: 14,) :
                                            aadharStatus1 == "N"  && checkAadharbackpath1 == "null" && checkAadharFrontPath1 == "null"? Icon(Icons.cancel,color: Colors.red,size: 14,)
                                                : Icon(Icons.watch_later,color: Colors.yellow,size: 14,),
                                            SizedBox(width: 3,),
                                            Text(
                                              getTranslated(context, 'Aadhaar Card'),
                                              style: TextStyle(
                                                fontSize: 12,),
                                            ),
                                          ],
                                        ),
                                        aadharNumber1== null  ? Container(
                                            margin: EdgeInsets.only(left: 3,top: 2),
                                            child: DoteLoader()): Text(aadharNumber1,style: TextStyle(fontSize: 16,),)
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      height: 28,
                                      child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: SecondaryColor.withOpacity(0.8),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(0),),
                                          padding: EdgeInsets.all(0),
                                          onPressed: aadharStatus1 == "N"  && checkAadharbackpath1 == "null" && checkAadharFrontPath1 == "null"? uploadAadhardialog : viewAadhardialog,
                                          child:aadharStatus1 == "N"  && checkAadharbackpath1 == "null" && checkAadharFrontPath1 == "null"? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                              SizedBox(width: 3,),
                                              Text(
                                                getTranslated(context, 'Upload'),
                                                style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ) : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.streetview_rounded,color: SecondaryColor,size: 16,),
                                              SizedBox(width: 3,),
                                              Text(
                                                getTranslated(context, 'View'),
                                                style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                              ),

                                            ],
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            panStatus1 == "Y" ? Icon(Icons.check_circle,color: Colors.green,size: 14,) :
                                            panStatus1 == "N"  && checkPanPath1 == "null" ? Icon(Icons.cancel,color: Colors.red,size: 14,)
                                                : Icon(Icons.watch_later,color: Colors.yellow,size: 14,),
                                            SizedBox(width: 3,),
                                            Text(
                                              getTranslated(context, 'Pan Card'),
                                              style: TextStyle(
                                                fontSize: 12,),
                                            ),
                                          ],
                                        ),
                                        panNumber1== null  ? Container(
                                            margin: EdgeInsets.only(left: 3,top: 2),
                                            child: DoteLoader()): Text(panNumber1,style: TextStyle(fontSize: 16,),)

                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      height: 28,
                                      child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: SecondaryColor.withOpacity(0.8),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(0),),
                                          padding: EdgeInsets.all(0),
                                          onPressed: (){

                                            setState(() {

                                              uploadType = getTranslated(context, 'upload PanCard Pic');
                                              viewType = getTranslated(context, 'View panCard pic');

                                            });


                                            if(panStatus1 == "N" && checkPanPath1 == "null" ){

                                              uploaddialog();
                                            }else{

                                              viewdialog();
                                            }


                                          },
                                          child:panStatus1 == "N"  && checkPanPath1 == "null" ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                              SizedBox(width: 3,),
                                              Text(
                                                getTranslated(context, 'Upload'),
                                                style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ) : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.streetview_rounded,color: SecondaryColor,size: 16,),
                                              SizedBox(width: 3,),
                                              Text(
                                                getTranslated(context, 'View'),
                                                style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                              ),

                                            ],
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            checkRegisterPath1 == "null" ?  Icon(Icons.cancel,color: Colors.red,size: 14,) :
                                            Icon(Icons.check_circle,color: Colors.green,size: 14,),
                                            SizedBox(width: 3,),
                                            Text(
                                              getTranslated(context, 'GSTCertificate'),
                                              style: TextStyle(
                                                fontSize: 12,),
                                            ),
                                          ],
                                        ),
                                        gstNumber1== null  ? Container(
                                            margin: EdgeInsets.only(left: 3,top: 2),
                                            child: DoteLoader()): Text(gstNumber1,style: TextStyle(fontSize: 16,),)

                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      height: 28,
                                      child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: SecondaryColor.withOpacity(0.8),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(0),),
                                          padding: EdgeInsets.all(0),
                                          onPressed: (){

                                            setState(() {

                                              uploadType = "upload Gst Certificate";
                                              viewType = getTranslated(context, 'View Gst pic');

                                            });


                                            if(checkRegisterPath1 == "null" ){

                                              uploaddialog();
                                            }else{

                                              viewdialog();
                                            }


                                          },
                                          child:checkRegisterPath1 ==  "null" ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                              SizedBox(width: 3,),
                                              Text(
                                                getTranslated(context, 'Upload'),
                                                style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ) : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.streetview_rounded,color: SecondaryColor,size: 16,),
                                              SizedBox(width: 3,),
                                              Text(
                                                getTranslated(context, 'View'),
                                                style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                              ),

                                            ],
                                          )
                                      ),
                                    )

                                  ],
                                ),
                              ],
                            ),
                          ),
                         /* Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.3),
                                          ),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'Selfie With Representative'),style: TextStyle(fontSize: 8,),textAlign: TextAlign.start,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                selfieShopStatus1 == "Y" ? Icon(Icons.check_circle,color: Colors.green,size: 20,) :
                                                selfieShopStatus1 == "N"  && checkSelfieShop1 == "null" ? Icon(Icons.cancel,color: Colors.red,size: 20,)
                                                    : Icon(Icons.watch_later,color: Colors.yellow,size: 20,),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 20,
                                                  width: 45,
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: FlatButton(
                                                    color: SecondaryColor.withOpacity(0.4),
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      setState(() {

                                                        uploadType = getTranslated(context, 'Selfie Upload');
                                                        viewType = getTranslated(context, 'Selfie View');

                                                      });

                                                      if(selfieShopStatus1 == "N" && checkSelfieShop1 == "null"){

                                                        uploaddialog();
                                                      }else{
                                                        viewdialog();
                                                      }

                                                    },
                                                    child:Text(selfieShopStatus1 == "N" && checkSelfieShop1 == "null"  ? "Upload"
                                                        :getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.3),
                                          ),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'Work Service Agreement'),style: TextStyle(fontSize: 8,),textAlign: TextAlign.start,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                serviceAgreeStatus1 == "true" ?Icon(Icons.check_circle,color: Colors.green,size: 20,)
                                                    : serviceAgreeStatus1 == "false" && checkServiceAgrementPath1 == "null" ?Icon(Icons.cancel,color: Colors.red,size: 20,)
                                                    :Icon(Icons.watch_later,color: Colors.yellow,size: 20,),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 20,
                                                  width: 45,
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: FlatButton(
                                                    color: SecondaryColor.withOpacity(0.4),
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0),),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      setState(() {
                                                        uploadType = "Service Agreement";
                                                        viewType = getTranslated(context, 'View Service Agreement');

                                                      });

                                                      if(serviceAgreeStatus1 == "false" && checkServiceAgrementPath1 == "null"){

                                                        uploaddialog();
                                                      }else{
                                                        viewdialog();
                                                      }

                                                    },
                                                    child:Text(serviceAgreeStatus1 == "false" && checkServiceAgrementPath1 == "null" ? "upload"
                                                        : getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.3),
                                          ),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'View Status My Video KYC'),style: TextStyle(fontSize: 8,),textAlign: TextAlign.start,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.pending,color: Colors.orange,size: 20,),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 20,
                                                  width: 45,
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: FlatButton(
                                                    color: SecondaryColor.withOpacity(0.4),
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0),),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      setState(() {
                                                      });
                                                    },
                                                    child:Text(getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: savebtn,
                child:
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: PrimaryColor.withOpacity(0.08),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: Offset(.0, .0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                    child: Container(
                      color: TextColor.withOpacity(0.5),
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.5),
                                      width: 3,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.6,
                                      child: Text(
                                        getTranslated(context, 'Personal Info'),
                                        style: TextStyle(
                                            fontSize: 20, color: SecondaryColor),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 26,
                                          width: 45,
                                          margin: EdgeInsets.only(top: 2),
                                          child: FlatButton(
                                            color: PrimaryColor,
                                            shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              setState(() {
                                                editbtn = true;
                                                savebtn = false;

                                              });
                                            },
                                            child:Text(getTranslated(context, 'Close'),style: TextStyle(fontSize: 12,color: TextColor),overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                        SizedBox(width: 3,),
                                        Container(
                                          height: 26,
                                          width: 45,
                                          margin: EdgeInsets.only(top: 2),
                                          child: FlatButton(
                                            color: SecondaryColor,
                                            shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              setState(() {
                                                editbtn = true;
                                                savebtn = false;

                                                dealerProfileUpload1(NameController.text,MobileController.text,DobController.text,
                                                  EmailController.text,PositionController.text,BusinessController.text,
                                                  AadhaarController.text,PenController.text,GstController.text,

                                                  FirmnameController.text,address1,pinCode1,districtId1,stateId1,pinNumber1,password1,joinDate1,cityName1,);

                                              });





                                            },
                                            child:Text(getTranslated(context, 'Save'),style: TextStyle(fontSize: 12,color: TextColor),),
                                          ),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: TextField(
                              controller: FirmnameController,
                              style: TextStyle(
                                fontSize: 14,
                                color: PrimaryColor,
                              ),
                              cursorColor: PrimaryColor,
                              cursorWidth: 1,
                              decoration: InputDecoration(
                                labelText: getTranslated(context, 'Business Name'),
                                isCollapsed: true,
                                labelStyle: TextStyle(color: PrimaryColor),
                                contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                              ),


                            ),


                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: NameController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(context, 'Name'),
                                            isCollapsed: true,
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),

                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Container(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: DobController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          onTap: () async {
                                            var date =  await showDatePicker(
                                                context: context,
                                                initialDate:DateTime.now(),
                                                helpText:getTranslated(context, 'Select date of birth'),
                                                builder: (context, child) {
                                                  return Theme(
                                                      data: ThemeData.light().copyWith(
                                                        primaryColor:SecondaryColor,
                                                        accentColor: SecondaryColor,
                                                        colorScheme: ColorScheme.light(
                                                          primary:SecondaryColor,
                                                          onSurface: Colors.white,
                                                          surface: Colors.white,

                                                        ),
                                                        inputDecorationTheme: InputDecorationTheme(
                                                          border: OutlineInputBorder(
                                                              borderSide:BorderSide(width: 1,color: TextColor)
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide:BorderSide(width: 1,color: TextColor)
                                                          ),
                                                          hintStyle: TextStyle(
                                                            color: TextColor,
                                                          ),
                                                        ),
                                                        textTheme: TextTheme(

                                                        ),
                                                        hintColor:SecondaryColor ,
                                                        buttonTheme: ButtonThemeData(
                                                          textTheme: ButtonTextTheme.primary,
                                                        ),
                                                        dialogBackgroundColor:PrimaryColor,
                                                      ),
                                                      // This will change to dark theme.
                                                      child:Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 50.0),
                                                          child: Container(
                                                            child: child,
                                                          ),
                                                        ),
                                                      )
                                                  );
                                                },
                                                firstDate:DateTime(1900),
                                                lastDate: DateTime(2050));

                                            DobController.text = date.toString().substring(0,10);
                                          },
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter(RegExp("[0-9/]")),
                                            LengthLimitingTextInputFormatter(10),

                                          ],
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoration(
                                            labelText: getTranslated(context, 'Date of Birth'),
                                            isCollapsed: true,
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: MobileController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText:getTranslated(context, 'Mobile No'),
                                            isCollapsed: true,
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: EmailController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(context, 'Email Id'),
                                            isCollapsed: true,
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: PositionController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(context, 'Position'),
                                            isCollapsed: true,
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: BusinessController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(context, 'Business Type'),
                                            isCollapsed: true,
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: AadhaarController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(context, 'Aadhaar Card'),
                                            isCollapsed: true,
                                            prefixIconConstraints:BoxConstraints(maxWidth: 20,minWidth: 15) ,
                                            prefixIcon: Icon(Icons.check_circle,color: Colors.green,size: 12,),
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 26,
                                            width: 90,
                                            margin: EdgeInsets.only(top: 2),
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              color: TextColor,
                                              shape:RoundedRectangleBorder(side: BorderSide(
                                                  color: SecondaryColor.withOpacity(0.8),
                                                  width: 1,
                                                  style: BorderStyle.solid
                                              ),borderRadius: new BorderRadius.circular(0),),
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                setState(() {
                                                });
                                              },
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.streetview_outlined,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Text(
                                                    getTranslated(context, 'View'),
                                                    style: TextStyle(color: SecondaryColor,fontSize: 16),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: TextField(
                                          controller: PenController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration:InputDecoration(
                                            labelText: getTranslated(context, 'Pan Card'),
                                            isCollapsed: true,
                                            prefixIconConstraints:BoxConstraints(maxWidth: 20,minWidth: 15) ,
                                            prefixIcon: Icon(Icons.cancel,color: Colors.red,size: 12,),
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 26,
                                            width: 90,
                                            margin: EdgeInsets.only(top: 2),
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              color: TextColor,
                                              shape:RoundedRectangleBorder(side: BorderSide(
                                                  color: SecondaryColor.withOpacity(0.8),
                                                  width: 1,
                                                  style: BorderStyle.solid
                                              ),borderRadius: new BorderRadius.circular(0),),
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                setState(() {
                                                });
                                              },
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Container(
                                                    width: 60,
                                                    child: Text(
                                                      getTranslated(context, 'Upload'),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: SecondaryColor,fontSize: 16),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: TextField(
                                              controller: GstController,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black
                                              ),
                                              decoration: InputDecoration(
                                                labelText: getTranslated(context, 'GSTCertificate'),
                                                isCollapsed: true,
                                                prefixIconConstraints:BoxConstraints(maxWidth: 20,minWidth: 15) ,
                                                prefixIcon: Icon(Icons.pending,color: Colors.orange,size: 12,),
                                                labelStyle: TextStyle(color: PrimaryColor),
                                                contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 26,
                                            width: 90,
                                            margin: EdgeInsets.only(top: 2),
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              color: TextColor,
                                              shape:RoundedRectangleBorder(side: BorderSide(
                                                  color: SecondaryColor.withOpacity(0.8),
                                                  width: 1,
                                                  style: BorderStyle.solid
                                              ),borderRadius: new BorderRadius.circular(0),),
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                setState(() {
                                                });
                                              },
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.streetview_outlined,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Text(
                                                    getTranslated(context, 'View'),
                                                    style: TextStyle(color: SecondaryColor,fontSize: 16),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.3),
                                          ),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'Selfie With Representative'),style: TextStyle(fontSize: 8,),textAlign: TextAlign.start,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.cancel,color: Colors.red,size: 20,),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 20,
                                                  width: 45,
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: FlatButton(
                                                    color: SecondaryColor.withOpacity(0.4),
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      setState(() {
                                                      });
                                                    },
                                                    child:Text(getTranslated(context, 'Upload'),style: TextStyle(fontSize: 10,),),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.3),
                                          ),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'Work Service Agreement'),style: TextStyle(fontSize: 8,),textAlign: TextAlign.start,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.check_circle,color: Colors.green,size: 20,),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 20,
                                                  width: 45,
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: FlatButton(
                                                    color: SecondaryColor.withOpacity(0.4),
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0),),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      setState(() {
                                                      });
                                                    },
                                                    child:Text(getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.3),
                                          ),),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'View Status My Video KYC'),style: TextStyle(fontSize: 8,),textAlign: TextAlign.start,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.watch_later,color: Colors.yellow[800],size: 20,),
                                                SizedBox(width: 3,),
                                                Container(
                                                  height: 20,
                                                  width: 45,
                                                  margin: EdgeInsets.only(top: 2),
                                                  child: FlatButton(
                                                    color: SecondaryColor.withOpacity(0.4),
                                                    shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0),),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      setState(() {
                                                      });
                                                    },
                                                    child:Text(getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Visibility(
                visible: editbtn2,
                child:
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: PrimaryColor.withOpacity(0.08),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: Offset(.0, .0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                    child: Container(
                      color: TextColor.withOpacity(0.5),
                      padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.5),
                                      width: 3,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.6,
                                      child: Text(
                                        getTranslated(context, 'Registered Business Address'),
                                        style: TextStyle(
                                            fontSize: 18, color: SecondaryColor),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      height: 27,
                                      width: 27,
                                      margin: EdgeInsets.only(top: 2),
                                      child: FlatButton(
                                        color: SecondaryColor,
                                        shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            editbtn2 = false;
                                            savebtn2 = true;
                                          });
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 14,
                                          color: TextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    address1== null  ? Container(
                                        margin: EdgeInsets.only(left: 3,top: 2),
                                        child: DoteLoader()): Container(
                                      padding: EdgeInsets.only(top: 5,bottom: 5),
                                      child: Text(address1, style: TextStyle(
                                        fontSize: 16,),
                                        textAlign: TextAlign.left,),
                                    )

                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'State'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      getTranslated(context, 'District'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    state1== null  ? Container(
                                        margin: EdgeInsets.only(left: 3,top: 2),
                                        child: DoteLoader()): Text(state1, style: TextStyle(
                                        fontSize: 14,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,),
                                    district1== null  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        DoteLoader(),
                                      ],
                                    ): Text(district1, style: TextStyle(
                                        fontSize: 14,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'City'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      getTranslated(context, 'Pin'),
                                      style: TextStyle(
                                        fontSize: 10,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    cityName1== null  ? Container(
                                        margin: EdgeInsets.only(left: 3,top: 2),
                                        child: DoteLoader()): Text(cityName1, style: TextStyle(
                                        fontSize: 14,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,),

                                    pinCode1== null  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        DoteLoader(),
                                      ],
                                    ): Text(pinCode1, style: TextStyle(
                                        fontSize: 14,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: savebtn2,
                child:
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: PrimaryColor.withOpacity(0.08),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: Offset(.0, .0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                    child: Container(
                      color: TextColor.withOpacity(0.5),
                      padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.5),
                                      width: 3,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.6,
                                      child: Text(
                                        getTranslated(context, 'Registered Business Address'),
                                        style: TextStyle(
                                            fontSize: 18, color: SecondaryColor),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      height: 26,
                                      width: 45,
                                      margin: EdgeInsets.only(top: 2),
                                      child: FlatButton(
                                        color: PrimaryColor,
                                        shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            editbtn2 = true;
                                            savebtn2 = false;

                                          });
                                        },
                                        child:Text(getTranslated(context, 'Close'),style: TextStyle(fontSize: 12,color: TextColor),),
                                      ),
                                    ),
                                    Container(
                                      height: 26,
                                      width: 45,
                                      margin: EdgeInsets.only(top: 2),
                                      child: FlatButton(
                                        color: SecondaryColor,
                                        shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            editbtn2 = true;
                                            savebtn2 = false;

                                            if(_mydis == null){

                                              setState(() {
                                                _mydis = districtId1;
                                              });
                                            }

                                            if(_myState == null){

                                              setState(() {
                                                _myState = stateId1;
                                              });

                                            }

                                            dealerProfileUpload1(name1,mobile1,dobDate1,
                                                email1,businessType1,businessTypeCode1,
                                                aadharNumber1,panNumber1,gstNumber1,
                                                firmName1,BusinessaddressController.text,PinController.text,
                                                _mydis,_myState,
                                                pinNumber1,password1,joinDate1,CityController.text);


                                          });
                                        },
                                        child:Text(getTranslated(context, 'Save'),style: TextStyle(fontSize: 12,color: TextColor),),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5, bottom: 5),
                                        child: TextField(
                                          controller: BusinessaddressController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                          ),
                                          decoration: InputDecoration(
                                            labelText:getTranslated(context, 'Address'),
                                            labelStyle: TextStyle(color: PrimaryColor),
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Visibility(
                                        visible: false,
                                        child: Text(getTranslated(context, 'space')),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5, left: 0, right: 0),
                                        child:OutlineButton(
                                          onPressed: statedialog,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          splashColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          clipBehavior: Clip.none,
                                          autofocus: false,
                                          disabledBorderColor: PrimaryColor,
                                          color: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          highlightedBorderColor: PrimaryColor,
                                          focusColor: PrimaryColor,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10, left: 10, right: 10),
                                          borderSide:
                                          BorderSide(width: 1, color: PrimaryColor),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    state=="Select State" ? state1:state,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: PrimaryColor,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  child:Icon(
                                                    Icons.arrow_drop_down,
                                                    color: PrimaryColor,
                                                  ),

                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5, left: 0, right: 0),
                                        child: OutlineButton(
                                          onPressed:districtdialog,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          splashColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          clipBehavior: Clip.none,
                                          autofocus: false,
                                          disabledBorderColor: PrimaryColor,
                                          color: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          highlightedBorderColor: PrimaryColor,
                                          focusColor: PrimaryColor,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10, left: 10, right: 10),
                                          borderSide:
                                          BorderSide(width: 1, color: PrimaryColor),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    district == "Select District" ? district1:district,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: PrimaryColor,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  child:Icon(
                                                    Icons.arrow_drop_down,
                                                    color: PrimaryColor,
                                                  ),

                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      controller: CityController,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black
                                      ),
                                      decoration: InputDecoration(
                                        labelText: getTranslated(context, 'City'),
                                        isCollapsed: true,
                                        labelStyle: TextStyle(color: PrimaryColor),
                                        contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width:10),
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      controller: PinController,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: PrimaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText:getTranslated(context, 'Pin Code'),
                                        isCollapsed: true,
                                        labelStyle: TextStyle(color: PrimaryColor),
                                        contentPadding: EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10,),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    ), onWillPop: backbtn);
  }
}
