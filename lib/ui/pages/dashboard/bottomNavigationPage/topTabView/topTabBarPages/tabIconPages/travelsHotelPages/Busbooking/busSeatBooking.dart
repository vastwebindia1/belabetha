import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';

class BusSeatBook extends StatefulWidget {
  const BusSeatBook({Key key}) : super(key: key);

  @override
  _BusSeatBookState createState() => _BusSeatBookState();
}



class _BusSeatBookState extends State<BusSeatBook>with SingleTickerProviderStateMixin {
  bool firstTap = true;
  bool secondTap = false;
  bool thirdTap = false;
  bool singleSeat=true;
  bool sleeperSeatCheck=false;

  bool threeSeat = true;
  bool seatTest = false;
  bool seatBooked = true;

  void changeLay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        thirdTap = false;
        singleSeat=true;
        sleeperSeatCheck=false;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        thirdTap=false;
        singleSeat=false;
        sleeperSeatCheck=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tabTextStyle= TextStyle(fontSize: 14,color: TextColor);
    TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: TextColor);
    return Material(
      child: SimpleAppBarWidget(
        title: Text(""),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: PrimaryColor,
                  child: Container(
                    color: TextColor.withOpacity(0.1),
                    padding: EdgeInsets.only(bottom: 15,top: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Jaipur To Sikar",style: TextStyle(color: TextColor,fontSize: 18),),
                          ],
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                          padding: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:firstTap ? SecondaryColor: TextColor,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    color: secondTap ? Colors.transparent: SecondaryColor,
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
                                        Icon(Icons.check_circle,size: 18,color: TextColor,),
                                        SizedBox(width: 2,),
                                        Text(
                                          "Lower Seat".toUpperCase(),
                                          style: tabTextStyle2,
                                        ),
                                      ],
                                    ):Text(
                                      "Lower Seat".toUpperCase(),
                                      style: tabTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:secondTap ? SecondaryColor: TextColor,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    color: firstTap ? Colors.transparent : SecondaryColor,
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
                                        Icon(Icons.check_circle,size: 18,color: TextColor,),
                                        SizedBox(width: 2,),
                                        Text(
                                          "Upper Seat".toUpperCase(),
                                          style: tabTextStyle2,
                                        ),
                                      ],
                                    ): Text("Upper Seat".toUpperCase(),
                                        style: tabTextStyle
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Transform.rotate(
                                  angle: 4.7,
                                  child: Image.asset(
                                    "assets/seat.png",
                                    color: Colors.red,
                                    width: 30,
                                  ),
                                ),
                              ),
                              Text("Available",textAlign: TextAlign.right,)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Transform.rotate(
                                  angle: 4.7,
                                  child: Image.asset(
                                    "assets/seat.png",
                                    color:Colors.green,
                                    width: 30,
                                  ),
                                ),
                              ),
                              Text("Selected")
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Transform.rotate(
                                  angle: 4.7,
                                  child: Image.asset(
                                    "assets/seat.png",
                                    color: Colors.orangeAccent,
                                    width: 30,
                                  ),
                                ),
                              ),
                              Text("Ladies")
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 270,
                      color: TextColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 30,bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment:Alignment.centerRight,
                                  width: 40,
                                  child: Image.asset(
                                    "assets/steering.png",
                                    color:Colors.lightBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment:threeSeat ? MainAxisAlignment.spaceBetween:MainAxisAlignment.end,
                            children: [
                              //Left Side Seats
                              Column(
                                children: [
                                  Visibility(
                                    visible: singleSeat,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          //first Row
                                          Column(
                                            children: [
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                setState(() {
                                                  if (seatTest == false) {
                                                    seatTest = true;
                                                  } else {
                                                    seatTest = false;
                                                  }
                                                });
                                              },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                            ],
                                          ),
                                          //Second Row
                                          Column(
                                            children: [
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                              BusSeatButton(
                                                seatTest: seatTest,
                                                onPressed: () {
                                                  setState(() {
                                                    if (seatTest == false) {
                                                      seatTest = true;
                                                    } else {
                                                      seatTest = false;
                                                    }
                                                  });
                                                },
                                                image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    replacement:Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //first Row
                                          BusSleeperButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/sleeperSeat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          SizedBox(height: 3,),
                                          BusSleeperButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/sleeperSeat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          SizedBox(height: 3,),
                                          BusSleeperButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/sleeperSeat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          SizedBox(height: 3,),
                                          BusSleeperButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/sleeperSeat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width:threeSeat ? 20:45,),
                              //Right Side Seat
                              Container(
                                child: Visibility(
                                  visible: singleSeat,
                                  child: Row(
                                    mainAxisAlignment:threeSeat == true ? MainAxisAlignment.end:MainAxisAlignment.center,
                                    children: [
                                      //First Row
                                      Visibility(
                                        visible: threeSeat,
                                        child: Column(
                                          children: [
                                            BusSeatButton(
                                              seatTest: seatTest,
                                              onPressed: () {
                                                setState(() {
                                                  if (seatTest == false) {
                                                    seatTest = true;
                                                  } else {
                                                    seatTest = false;
                                                  }
                                                });
                                              },
                                              image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                            ),
                                            BusSeatButton(
                                              seatTest: seatTest,
                                              onPressed: () {
                                                setState(() {
                                                  if (seatTest == false) {
                                                    seatTest = true;
                                                  } else {
                                                    seatTest = false;
                                                  }
                                                });
                                              },
                                              image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                            ),
                                            BusSeatButton(
                                              seatTest: seatTest,
                                              onPressed: () {
                                                setState(() {
                                                  if (seatTest == false) {
                                                    seatTest = true;
                                                  } else {
                                                    seatTest = false;
                                                  }
                                                });
                                              },
                                              image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                            ),
                                            BusSeatButton(
                                              seatTest: seatTest,
                                              onPressed: () {
                                                setState(() {
                                                  if (seatTest == false) {
                                                    seatTest = true;
                                                  } else {
                                                    seatTest = false;
                                                  }
                                                });
                                              },
                                              image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                            ),
                                            BusSeatButton(
                                              seatTest: seatTest,
                                              onPressed: () {
                                                setState(() {
                                                  if (seatTest == false) {
                                                    seatTest = true;
                                                  } else {
                                                    seatTest = false;
                                                  }
                                                });
                                              },
                                              image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //Second Row
                                      Column(
                                        children: [
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                        ],
                                      ),
                                      //Third Row
                                      Column(
                                        children: [
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                          BusSeatButton(
                                            seatTest: seatTest,
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            image: Image.asset("assets/seat.png",color: seatTest ? Colors.blue :Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  replacement: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //first Row
                                        Container(
                                          width: 90,
                                          child: TextButton(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all(EdgeInsets.zero)
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                          width: 90,
                                          child: TextButton(
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all(EdgeInsets.zero)
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                          width: 90,
                                          child: TextButton(
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all(EdgeInsets.zero)
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                          width: 90,
                                          child: TextButton(
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all(EdgeInsets.zero)
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
                                                ),
                                                Image.asset(
                                                  "assets/sleeperSeat.png",
                                                  color: seatTest ? Colors.blue : Colors.red,
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
                            ],
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:threeSeat ? MainAxisAlignment.end:MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 45,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/seat.png",
                                              color: seatTest ? Colors.blue : Colors.red,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 45,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/seat.png",
                                              color: seatTest ? Colors.blue : Colors.red,
                                            ),
                                          ),
                                        ),
                                        threeSeat ?Container(
                                          width: 45,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/seat.png",
                                              color: seatTest ? Colors.blue : Colors.red,
                                            ),
                                          ),
                                        ):Container(),
                                        Container(
                                          width: 45,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/seat.png",
                                              color: seatTest ? Colors.blue : Colors.red,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 45,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/seat.png",
                                              color: seatTest ? Colors.blue : Colors.red,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 45,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (seatTest == false) {
                                                  seatTest = true;
                                                } else {
                                                  seatTest = false;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/seat.png",
                                              color: seatTest ? Colors.blue : Colors.red,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

class BusSeatButton extends StatelessWidget {
  final VoidCallback  onPressed;
  final Color seatColor;
  final Image image;
  const BusSeatButton({
    Key key, this.onPressed, this.seatColor, this.seatTest, this.image,
  }) : super(key: key);

  final bool seatTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      child: TextButton(
        onPressed: onPressed,

        child:image,
      ),
    );
  }
}

class BusSleeperButton extends StatelessWidget {
  final VoidCallback  onPressed;
  final Color seatColor;
  final Image image;
  const BusSleeperButton({
    Key key, this.onPressed, this.seatColor, this.seatTest, this.image,
  }) : super(key: key);

  final bool seatTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: TextButton(
        style: ButtonStyle(

            padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: onPressed,

        child:image,
      ),
    );
  }
}
