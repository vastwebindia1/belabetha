import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

class DealerAddMoneyHistory extends StatefulWidget {
  const DealerAddMoneyHistory({Key key}) : super(key: key);

  @override
  _DealerAddMoneyHistoryState createState() => _DealerAddMoneyHistoryState();
}

class _DealerAddMoneyHistoryState extends State<DealerAddMoneyHistory> {
  List fundrecive = [];

  String frmDate = "";
  String toDate = "";
  String Name = "";
  String bal_type = "";
  String date_dlm = "";
  String balance = "";
  String dealer_prebal = "";
  String dealer_postbal = "";
  String cr = "";
  String Oldcreditbalance = "";

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary: SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: TextColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: TextColor)),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(),
                hintColor: SecondaryColor,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor: PrimaryColor,
              ),
              // This will change to dark theme.
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    child: child,
                  ),
                ),
              ));
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary: SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: TextColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: TextColor)),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(),
                hintColor: SecondaryColor,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor: PrimaryColor,
              ),
              // This will change to dark theme.
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    child: child,
                  ),
                ),
              ));
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });
  }

  Future<void> dealledgr(String frmDate, String toDate) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http(
        "api.vastwebindia.com", "api/Dealer/ReceiveFund_by_admin", {
      "txt_frm_date": frmDate,
      "txt_to_date": toDate,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rep = data["Report"];

      setState(() {
        fundrecive = rep;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  List<String> options = <String>[
    'Select By',
    'Receive From Admin',
    'Receive From Master',
  ];

  String dropdownValue = 'Select By';

  ScrollController listScroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];

    dealledgr(frmDate, toDate);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: StickyHeader(
            header: Container(
              color: TextColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: PrimaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: TextColor.withOpacity(0.1),
                          padding: EdgeInsets.only(top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: PrimaryColor,
                                        )),
                                    margin: EdgeInsets.only(left: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2,
                                          left: 10,
                                          right: 17,
                                          bottom: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.calendar_today_outlined,
                                              size: 25,
                                              color: TextColor,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _selectDate2(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getTranslated(context, 'From Date'),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: TextColor),
                                                ),
                                                Text(
                                                  "${selectedDate2.toLocal()}"
                                                      .split(' ')[0],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: TextColor),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: PrimaryColor,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2,
                                          left: 10,
                                          right: 17,
                                          bottom: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.calendar_today_outlined,
                                              size: 25,
                                              color: TextColor,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getTranslated(
                                                      context, 'To Date'),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: TextColor),
                                                ),
                                                Text(
                                                  "${selectedDate2.toLocal()}"
                                                      .split(' ')[0],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: TextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    height: 40,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: PrimaryColor,
                                        ),
                                        color: SecondaryColor),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                      ),
                                      iconSize: 25,
                                      color: TextColor,
                                      splashColor: Colors.purple,
                                      onPressed: () {
                                        frmDate = "${selectedDate2.toLocal()}"
                                            .split(' ')[0];
                                        toDate = "${selectedDate.toLocal()}"
                                            .split(' ')[0];
                                        dealledgr(frmDate, toDate);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 45,
                                margin: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: PrimaryColor,
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: dropdownValue,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 1, 1, 1),
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  style: const TextStyle(color: PrimaryColor),
                                  selectedItemBuilder: (BuildContext context) {
                                    return options.map((String value) {
                                      return Text(
                                        dropdownValue,
                                        style: const TextStyle(
                                            color: TextColor),
                                      );
                                    }).toList();
                                  },
                                  items: options.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
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
            content: Container(
              alignment: Alignment.center,
              color: TextColor,
              child: fundrecive.length == 0
                  ? Container(height: 50, child: DoteLoader())
                  : ListView.builder(
                      controller: listScroll,
                      shrinkWrap: true,
                      itemCount: fundrecive.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: PrimaryColor.withOpacity(0.08),
                                      blurRadius: .5,
                                      spreadRadius: 1,
                                      offset: Offset(.0,
                                          .0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 6, bottom: 0),
                                padding: EdgeInsets.all(1.0),
                                child: Container(
                                  color: TextColor.withOpacity(0.5),
                                  padding: EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Container(
                                        transform: Matrix4.translationValues(
                                            0.0, -2.0, 0.0),
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                getTranslated(context, 'Name') ,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              SizedBox(
                                                                height: 1,
                                                              ),
                                                              Text(
                                                                fundrecive[index]
                                                                        ["Name"]
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "Type".toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 1,
                                                      ),
                                                      Text(
                                                        fundrecive[index]
                                                                ["bal_type"]
                                                            .toString(),
                                                        style: TextStyle(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Container(
                                          color: TextColor,
                                          padding: EdgeInsets.only(
                                              bottom: 4,
                                              top: 4,
                                              left: 2,
                                              right: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Transaction Time',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                fundrecive[index]["date_dlm"]
                                                    .toString(),
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5),
                                          color: TextColor,
                                          padding: EdgeInsets.only(
                                              bottom: 4,
                                              top: 4,
                                              left: 2,
                                              right: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Transfer',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                fundrecive[index]["balance"]
                                                    .toString(),
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        transform: Matrix4.translationValues(
                                            0.0, 0.0, 0.0),
                                        margin: EdgeInsets.only(top: 4),
                                        padding:
                                            EdgeInsets.fromLTRB(4, 2, 2, 4),
                                        color: TextColor,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "R. Pri",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              SizedBox(
                                                                height: 1,
                                                              ),
                                                              Text(
                                                                fundrecive[index]
                                                                        [
                                                                        "dealer_prebal"]
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "R. Post",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SizedBox(
                                                                height: 1,
                                                              ),
                                                              Text(
                                                                fundrecive[index]
                                                                        [
                                                                        "dealer_postbal"]
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "C. Credit",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SizedBox(
                                                                height: 1,
                                                              ),
                                                              Text(
                                                                fundrecive[index]
                                                                        ["cr"]
                                                                    .toString(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        getTranslated(context, 'Old Credit')
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 1,
                                                      ),
                                                      Text(
                                                        fundrecive[index][
                                                                "Oldcreditbalance"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.right,
                                                      )
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
                            ),
                          ],
                        );
                      }),
            ),
          ),
        ),
      ),
    );
  }
}
