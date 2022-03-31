import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class Complaint extends StatefulWidget {
  const Complaint({
    Key key,
  }) : super(key: key);

  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  List respmsz = [];

  Future<void> chatmszapi(String chatmsz) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url1 = new Uri.http(
        "api.vastwebindia.com", "/Common/api/data/ComplainRequest", {
      "subject": "chatting",
      "Complaint": chatmsz,
    });

    final http.Response response = await http.post(
      url1,
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
    } else {
      throw Exception('Failed to load themes');
    }
  }

  String frmDate = "";
  String toDate = "";
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.utc(5);

  Future<void> responsemszapi() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url1 = new Uri.http(
        "api.vastwebindia.com", "/Common/api/data/ComplainRequestReport", {
      "txt_frm_date": frmDate,
      "txt_to_date": toDate,
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
      var status = dataa["Response"];
      var msz = dataa["Report"];

      setState(() {
        respmsz = msz;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  DateTime currentDate = DateTime.now();
  String currentDate1;
  String formattedDate;
  String mszz;

  String subject = "Admin";
  ScrollController listScroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];

    responsemszapi();
    formattedDate = DateFormat('dd-MM-yyyy – hh:mm a').format(DateTime.now());
  }


  void _handleSubmitted(String text) {
    formattedDate=(DateTime.now().millisecondsSinceEpoch.toString());
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  bool mzzz = false;

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    semanticContainer: true,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: TextFormField(
                      maxLength: 500,
                      buildCounter: (BuildContext context,
                          {int currentLength,
                            int maxLength,
                            bool isFocused}) =>
                      null,
                      controller: _textController,
                      maxLines: null,
                      autocorrect: true,
                      onChanged: (String value) {
                        setState(() {
                          _isComposing = value.length > 0;
                        });
                        setState(() {
                          if (value.length > 1) {
                            setState(() {
                              mzzz = true;
                            });
                          } else {
                            setState(() {
                              mzzz = false;
                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: false,
                        hintText: 'Type Text Here...',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor:TextColor,
                        contentPadding: EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ), floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _isComposing ? Colors.white70 : Colors.white70,
                  ),
                  child: Container(
                    child: new IconButton(
                        icon: new Icon(
                          Icons.send,
                          color: PrimaryColor,
                        ),
                        onPressed: mzzz
                            ? () {
                          chatmszapi(_textController.text);
                          _handleSubmitted(_textController.text);
                        }
                            : () {}),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool loaderRun = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (respmsz.length == 0) {
        loaderRun = true;
      } else {
        loaderRun = false;
      }
    });
    return Material(
      child: Container(
        color: PrimaryColor,
        child: Container(
          color: TextColor.withOpacity(0.5),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: TextColor,
              appBar: AppBar(
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Icon(
                          Icons.comment_outlined,
                          color: TextColor,
                          size: 28,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, 'Selected Info'),
                            style: TextStyle(
                                color: TextColor,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            getTranslated(context, 'Complain Chat'),
                            style: TextStyle(
                                color: TextColor, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                backgroundColor: PrimaryColor,
                toolbarHeight: 39,
                leading: BackButtonsApBar(),
                leadingWidth: 60,
              ),
              body: Container(
                color: TextColor,
                child: Column(children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: FutureBuilder(
                        builder: (context, projectSnap) {
                          if (projectSnap.connectionState ==
                              ConnectionState.none &&
                              projectSnap.hasData == null) {
                            //print('project snapshot data is: ${projectSnap.data}');
                            return Container();
                          }
                          return ListView.builder(
                            itemCount: respmsz.length,
                            controller: listScroll,
                            reverse: true,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: respmsz[index]["Complaint"] ==
                                          null
                                          ? Visibility(
                                          visible: false,
                                          child: Text("data"))
                                          : Column(
                                        children: [
                                          ChatBubble(
                                            clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, nipWidth: 12,radius: 5),
                                            backGroundColor:PrimaryColor.withOpacity(0.8),
                                            alignment: Alignment.topRight,
                                            margin: EdgeInsets.only(top: 20),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minWidth: 100,
                                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    constraints:
                                                    BoxConstraints(
                                                        maxWidth:
                                                        250,
                                                        minWidth:
                                                        140),
                                                    padding: EdgeInsets
                                                        .only(
                                                        bottom:
                                                        15),
                                                    child: Text(
                                                      respmsz[index]
                                                      [
                                                      "Complaint"] ==
                                                          null
                                                          ? ""
                                                          : respmsz[
                                                      index]
                                                      ["Complaint"],
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          16),
                                                      textAlign:
                                                      TextAlign
                                                          .left,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      softWrap:
                                                      true,
                                                      maxLines: 40,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Text(
                                                      formattedDate,
                                                      style: TextStyle(
                                                          fontSize:
                                                          10,
                                                          color: Colors
                                                              .white),
                                                      textAlign:
                                                      TextAlign
                                                          .right,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )

                                        ],
                                      ),

                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: respmsz[index][
                                      "ResponseMsg"] ==
                                          null
                                          ? Visibility(
                                          visible: false,
                                          child: Text("data"))
                                          : Column(
                                        children: [
                                          ChatBubble(
                                            clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble, nipWidth: 12,radius: 5),
                                            backGroundColor:SecondaryColor.withOpacity(0.8),
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(top: 20),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minWidth: 100,
                                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                                              ),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    constraints:
                                                    BoxConstraints(
                                                        maxWidth:
                                                        250,
                                                        minWidth:
                                                        140),
                                                    padding:
                                                    EdgeInsets.only(
                                                        bottom: 15),
                                                    child: Text(
                                                      respmsz[index][
                                                      "ResponseMsg"],
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 16),
                                                      textAlign:
                                                      TextAlign
                                                          .left,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      softWrap: true,
                                                      maxLines: 40,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Text(
                                                      respmsz[index]
                                                      ["RequestDate"],
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                      textAlign:TextAlign.right,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        future: responsemszapi(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    color: PrimaryColor,
                    child: _buildTextComposer(),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
