import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/qrCodePage.dart';

import '../../dashboard.dart';


class Qrwithamnt extends StatefulWidget {
  const Qrwithamnt({Key key, this.minamnt, this.maxamnt, this.status}) : super(key: key);
  final String minamnt,maxamnt,status;

  @override
  _QrwithamntState createState() => _QrwithamntState();
}

class _QrwithamntState extends State<Qrwithamnt> {

  final TextEditingController amount = TextEditingController();


  Future<void> Qrcodestatus(String amntaq) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/UPI/api/data/UPI_Transfer",{
      "amountqr":amntaq
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
      var data = json.decode(response.body);
      var status = data["Status"];
      var msz = data["Message"];

      if(status == "Success"){

        Navigator.push(context, MaterialPageRoute(builder: (_) => QRCodePage(qramount: amount.text,status: widget.status,)));


      }else if(msz =="Create") {

        Navigator.push(context, MaterialPageRoute(builder: (_) => QRCodePage(qramount: amount.text,status: widget.status,)));

      } else {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }



    } else {
      throw Exception('Failed');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15,bottom: 15,),
              decoration: BoxDecoration(
                color:PrimaryColor.withOpacity(0.9),),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                                          child: Image.asset('assets/pngImages/qr-code.png'),
                                        ),
                                        SizedBox(height: 5,),
                                        Text("QR Code",style: TextStyle(color: TextColor,fontSize: 18,),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned (
                                top: 0,
                                left: 0,
                                child: IconButton(
                                  onPressed:(){
                                    Navigator.pushReplacement(context, PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) => Dashboard(),
                                        transitionDuration: Duration(seconds: 0),
                                      ),);
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
              height: 20,
            ),
            Container(
              child: InputTextField(
                label: getTranslated(context, 'Enter Amount'),
                maxLength: 12,
                controller: amount,
                obscureText: false,
                keyBordType: TextInputType.number,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                onChange: (String val){

                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Text("* Enter Amount Should be between \u{20B9}${widget.minamnt} To \u{20B9}${widget.maxamnt}",textAlign: TextAlign.justify,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor:SecondaryColor ,
                        shadowColor:Colors.transparent,),
                      onPressed:()async{

                        int amnt = int.parse(amount.text);

                        if(amount.text == "" || amnt <100 || amnt >500){


                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text("Please Enter Valid Amount !!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else {

                          Qrcodestatus(amount.text);

                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text("NEXT",textAlign: TextAlign.center,style: TextStyle(color: TextColor,fontSize: 18),)
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
      ),
    );
  }
}
