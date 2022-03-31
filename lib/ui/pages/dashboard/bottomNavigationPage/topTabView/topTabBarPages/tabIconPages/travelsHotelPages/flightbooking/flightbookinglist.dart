import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/travelsHotelPages/flightbooking/flightseatbooking.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';

class FlightBookingList extends StatefulWidget {


  @override
  _FlightBookingListState createState() => _FlightBookingListState();
}

ScrollController _controllerList = ScrollController();
class _FlightBookingListState extends State<FlightBookingList> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SimpleAppBarWidget(
          title:Align(
              alignment:  Alignment(-.3, 0),
              child: Text("Select Flight",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.8)
                  ),
                  padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("assets/pngImages/Flight.png",),width: 40,),
                      SizedBox(width: 10,),
                      Text("Jaipur To Delhi",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TextColor),)
                    ],
                  ),
                ),
                ListView.builder(
                  controller: _controllerList,
                  shrinkWrap: true,
                  itemCount: 10,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child:  Column(
                        children: [
                          Container(
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
                            child: Container(
                              margin: EdgeInsets.only(left: 0.5,right: 0.5,
                                  top: 0.5,bottom: 0.5),
                              child: Container(
                                color:Colors.white.withOpacity(0.5),
                                padding: EdgeInsets.only(top: 1, bottom: 0, left: 1, right: 1),
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(PrimaryColor),
                                    overlayColor: MaterialStateProperty.all(SecondaryColor.withOpacity(0.2)),

                                  ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => FlightSeatBook()));

                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1,color: SecondaryColor),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image(image: AssetImage("assets/pngImages/Flight.png",),width: 25,)),
                                              SizedBox(width: 5,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Air India",style: TextStyle(color: PrimaryColor,fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                                  Text("Business Class",),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(getTranslated(context, 'Amount')),
                                              Text("\u{20B9} 3600",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                            ],
                                          ),

                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 3,bottom: 2),
                                        height: 1,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1,color: PrimaryColor.withOpacity(0.2))
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Dep. Time",),
                                                Text("15:30",),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Arrival Time",),
                                                Text("16:00",),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text("Duration Time",style: TextStyle(color: SecondaryColor)),
                                                Text("30m",style: TextStyle(color: SecondaryColor),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Expanded(
                                            child: Text("2021/07/14",),
                                          ),
                                          Expanded(
                                            child: Text("2021/07/14",textAlign: TextAlign.right,),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 3,bottom: 2),
                                        height: 1,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1,color: PrimaryColor.withOpacity(0.2))
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Expanded(
                                            flex: 1,
                                            child: Text("Seat Available:40",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: SecondaryColor),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}
