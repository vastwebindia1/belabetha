import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class MasterBankAdd extends StatefulWidget {
  const
  MasterBankAdd({Key key}) : super(key: key);

  @override
  _MasterBankAddState createState() => _MasterBankAddState();
}
TextEditingController controller = TextEditingController();
TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();
TextEditingController controller3 = TextEditingController();
TextEditingController controller4 = TextEditingController();

bool visibleInput = false;
bool visibleText = true;
bool buttonVisible = false;

ScrollController scrollController = ScrollController();

class _MasterBankAddState extends State<MasterBankAdd> {

  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions1 = [
    MasterBank(),
    MasterWallet(),
  ];

  bool firstTap = true;
  bool secondTap = false;

  void changeLay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        selectedIndex = 1;
      });
    }
  }

  TextStyle tabTextStyle= TextStyle(fontSize: 14,color: TextColor);
  TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: TextColor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: TextColor,

      body: Material(

        child: SafeArea(

          child: SingleChildScrollView(

            child: Container(

              child: Column(
                children: [

                  Container(
                    padding: EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 0,
                                left: 0,
                                bottom: 10,
                                right: 0,
                              ),
                              decoration: BoxDecoration(),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        margin: EdgeInsets.only(top: 0),
                                        child: IconButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: SecondaryColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:firstTap ? SecondaryColor: PrimaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  color: secondTap ? PrimaryColor.withOpacity(0.8) : PrimaryColor.withOpacity(0.9),
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
                                                      Icon(Icons.check_circle,size: 16,color: TextColor,),
                                                      SizedBox(width: 2,),
                                                      Text(
                                                        "Bank Account".toUpperCase(),
                                                        style: tabTextStyle2,
                                                      ),
                                                    ],
                                                  ):Text(
                                                    "Bank Account".toUpperCase(),
                                                    style: tabTextStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:secondTap ? SecondaryColor: PrimaryColor,
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  color:firstTap ? PrimaryColor.withOpacity(0.8): PrimaryColor.withOpacity(0.9),
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
                                                      Icon(Icons.check_circle,size: 16,color: TextColor,),
                                                      SizedBox(width: 2,),
                                                      Text(
                                                        "Wallet".toUpperCase(),
                                                        style: tabTextStyle2,
                                                      ),
                                                    ],
                                                  ): Text("Wallet".toUpperCase(),
                                                    style: tabTextStyle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 0,),


                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  Container(child: _widgetOptions1.elementAt(selectedIndex))

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MasterWallet extends StatefulWidget {
  const MasterWallet({Key key}) : super(key: key);

  @override
  _MasterWalletState createState() => _MasterWalletState();
}

class _MasterWalletState extends State<MasterWallet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding:EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    border:visibleInput ? Border() : Border(
                        bottom: BorderSide(
                          color: PrimaryColor.withOpacity(0.1),
                          width: 1,
                        ))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_sharp,
                              size: 16,
                              color: SecondaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Wallet Info",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: SecondaryColor),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        visibleInput ? IconButton(
                          onPressed: () {
                            setState(() {
                              visibleText = true;
                              visibleInput = false;
                              buttonVisible = false;
                              controller.clear();
                              controller1.clear();
                              controller2.clear();
                              controller3.clear();
                              controller4.clear();
                            });
                          },
                          icon: Icon(Icons.close),
                        ) :
                        IconButton(
                          onPressed: () {
                            setState(() {
                              visibleInput = true;
                              visibleText = false;
                              buttonVisible = true;
                            });
                          },
                          icon: Icon(Icons.edit),
                        )
                      ],
                    ),
                    Visibility(
                      maintainSize: false,
                      visible: visibleText,
                      child: Container(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller4.text.length == 0 ? "Paytm":controller4.text,
                                  style: TextStyle(fontSize: 20,color:PrimaryColor),
                                  overflow:TextOverflow.clip,
                                  textAlign: TextAlign.left,
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
              Visibility(
                visible: visibleText,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: PrimaryColor.withOpacity(0.1),
                                width: 1,
                              ))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Wallet Name",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  controller.text.length == 0 ? "xyz":
                                  controller.text,
                                  style:
                                  TextStyle(fontSize: 17),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: PrimaryColor.withOpacity(0.1),
                                width: 1,
                              ))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'Wallet Holder'),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller1.text.length == 0 ? "xyz":
                                      controller1.text,
                                      style:
                                      TextStyle(fontSize: 17),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Wallet Number",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller3.text.length == 0 ? "abc":
                                    controller3.text,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visibleInput,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: "Wallet Name",
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller1,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: getTranslated(context, 'Wallet Holder'),
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller2,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: "Wallet Number",
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                  visible: buttonVisible,
                                  child: MainButton(
                                    onPressed: () {
                                      setState(() {
                                        if (visibleInput == true) {
                                          visibleInput = false;
                                          visibleText = true;
                                          buttonVisible = false;
                                        }
                                      });
                                    },
                                    style: TextStyle(
                                        color: TextColor),
                                    color: SecondaryColor,
                                    btnText: getTranslated(context, 'Save'),
                                  )),
                            ),
                          )
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
    );
  }
}


class MasterBank extends StatefulWidget {
  const MasterBank({Key key}) : super(key: key);

  @override
  _MasterBankState createState() => _MasterBankState();
}

class _MasterBankState extends State<MasterBank> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding:EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    border:visibleInput ? Border() : Border(
                        bottom: BorderSide(
                          color: PrimaryColor.withOpacity(0.1),
                          width: 1,
                        ))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_sharp,
                              size: 16,
                              color: SecondaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              getTranslated(context, 'Bank Account Info') ,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: SecondaryColor),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        visibleInput ? IconButton(
                          onPressed: () {
                            setState(() {
                              visibleText = true;
                              visibleInput = false;
                              buttonVisible = false;
                              controller.clear();
                              controller1.clear();
                              controller2.clear();
                              controller3.clear();
                              controller4.clear();
                            });
                          },
                          icon: Icon(Icons.close),
                        ) :
                        IconButton(
                          onPressed: () {
                            setState(() {
                              visibleInput = true;
                              visibleText = false;
                              buttonVisible = true;
                            });
                          },
                          icon: Icon(Icons.edit),
                        )
                      ],
                    ),
                    Visibility(
                      maintainSize: false,
                      visible: visibleText,
                      child: Container(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller4.text.length == 0 ? "ICICI":controller4.text,
                                  style: TextStyle(fontSize: 20,color:PrimaryColor),
                                  overflow:TextOverflow.clip,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      visible: visibleInput,
                      child:Container(
                          height: 40,
                          child: TextFormField(
                            controller: controller4,
                            decoration:InputDecoration(
                                contentPadding:EdgeInsets.only(left: 10),
                                labelText: getTranslated(context, 'Bank Name'),
                                labelStyle: TextStyle(color: PrimaryColor)
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visibleText,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: PrimaryColor.withOpacity(0.1),
                                width: 1,
                              ))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'AC Name') ,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  controller.text.length == 0 ? "Ramniwas":
                                  controller.text,
                                  style:
                                  TextStyle(fontSize: 17),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: PrimaryColor.withOpacity(0.1),
                                width: 1,
                              ))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'A/C Number') ,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller1.text.length == 0 ? "123456789002":
                                      controller1.text,
                                      style:
                                      TextStyle(fontSize: 17),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: PrimaryColor.withOpacity(0.1),
                                width: 1,
                              ))),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'IFSCode') ,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller2.text.length == 0 ? "ICICI0001":
                                      controller2.text,
                                      style:
                                      TextStyle(fontSize: 17),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated(context, 'Branch') ,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller3.text.length == 0 ? "Sikar":
                                    controller3.text,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visibleInput,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: getTranslated(context, 'A/C Holder Name') ,
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller1,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: getTranslated(context, 'A/C Number') ,
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller2,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: getTranslated(context, 'IFSCode') ,
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child: TextFormField(
                                      controller: controller3,
                                      decoration:InputDecoration(
                                          contentPadding:EdgeInsets.only(left: 10),
                                          labelText: getTranslated(context, 'Branch') ,
                                          labelStyle: TextStyle(color: PrimaryColor)
                                      ),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                  visible: buttonVisible,
                                  child: MainButton(
                                    onPressed: () {
                                      setState(() {
                                        if (visibleInput == true) {
                                          visibleInput = false;
                                          visibleText = true;
                                          buttonVisible = false;
                                        }
                                      });
                                    },
                                    style: TextStyle(
                                        color: TextColor),
                                    color: SecondaryColor,
                                    btnText: getTranslated(context, 'Save'),
                                  )),
                            ),
                          )
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
    );
  }
}
