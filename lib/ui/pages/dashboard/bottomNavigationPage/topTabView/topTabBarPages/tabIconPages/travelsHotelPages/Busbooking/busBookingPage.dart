import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/addMoney.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';

import 'busBookingList.dart';

class BusBooking extends StatefulWidget {
  @override
  _BusBookingState createState() => _BusBookingState();
}

Image image1;
String frmDate = "";

class _BusBookingState extends State<BusBooking>with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    frmDate = "${selectedDate.toLocal()}".split(' ')[0];
    image1 = Image.asset(
      'assets/pngImages/bus.png',
      width: 40,
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
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
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  TextEditingController fromcont = TextEditingController();
  TextEditingController tocont = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  bool dir = true;

  @override
  Widget build(BuildContext context) {
    _animation = Tween<double>(
        begin: dir ? 0:0.5,
        end: dir ? 0.5:1
    ).animate(_controller);
    return Material(
      child: AppBarWidget(
        title: Text(""),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    10,
                  ),
                  decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(0.8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 0,
                          left: 0,
                          bottom: 10,
                          right: 0,
                        ),
                        decoration: BoxDecoration(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: TextColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(50.0),
                                    ),
                                    color: TextColor),
                                child: image1),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        getTranslated(context, 'Bus Booking'),
                        style: TextStyle(
                          color: TextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                              keyboardType: TextInputType.number,
                              controller: fromcont,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                isDense: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                labelText: "From Station",
                                hintText: "From Station",
                                labelStyle: TextStyle(color: PrimaryColor),
                                hintStyle: TextStyle(color: PrimaryColor),
                              ),
                              maxLength: 10,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                              keyboardType: TextInputType.number,
                              controller: tocont,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                isDense: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                labelText: "To Station",
                                hintText: "To Station",
                                labelStyle: TextStyle(color: PrimaryColor),
                                hintStyle: TextStyle(color: PrimaryColor),
                              ),
                              maxLength: 10,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: DecoratedBox(
                          decoration:BoxDecoration(
                            border: Border.all(width: 1,color: PrimaryColor),
                            shape: BoxShape.circle,
                          ) ,
                          child: SizedBox(
                            width: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  shape:MaterialStateProperty.all(CircleBorder(),
                                  ),
                                ),
                                onPressed: (){
                                  _controller.forward(from: 0);
                                  setState(() {
                                    dir = !dir;

                                    String fromdata = fromcont.text;
                                    String todata = tocont.text;

                                    fromcont.text = todata;
                                    tocont.text = fromdata;

                                  });

                                },
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (_, child) {
                                    return RotationTransition(
                                      turns:_animation,
                                      child: Transform.rotate(
                                        angle:4.75,
                                        child: Icon(
                                          Icons.compare_arrows_sharp,
                                          size: 22,
                                          color: PrimaryColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              ),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 8, right: 10, bottom: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: PrimaryColor),
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Date'),
                                      style: TextStyle(
                                          fontSize: 10, color: PrimaryColor),
                                    ),
                                    Text(
                                      "${selectedDate.toLocal()}"
                                          .split(' ')[0],
                                      style: TextStyle(
                                          fontSize: 14, color: PrimaryColor),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    size: 25,
                                    color: PrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: MainButton(
                      color: SecondaryColor,
                      btnText:getTranslated(context, 'Submit'),
                      style: TextStyle(color: TextColor),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BusBookingList()));
                      },
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
