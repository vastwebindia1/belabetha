import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import '../../main.dart';
import 'Languages/language.dart';
import 'Languages/localization/language_constants.dart';



class LanguageChange extends StatefulWidget {
  final int id;
  final String name;
  final String languageCode;


  const LanguageChange({Key key, this.id, this.name, this.languageCode}) : super(key: key);

  @override
  _LanguageChangeState createState() => _LanguageChangeState();
}

class _LanguageChangeState extends State<LanguageChange> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Locale _locale;


  void _changeLanguage(Language language) async {
    _locale = await setLocale(language.languageCode);
    print(_locale);
    MyApp.setLocale(context, _locale);


  }

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();

  List lang = Language.languageList();

  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {

        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      didChangeDependencies();
    });

  }



  @override
  Widget build(BuildContext context) {
    print(lang);
    print(_locale.languageCode);
    setState(() {

    });
    return Scaffold(
        backgroundColor: TextColor,
        body: SafeArea(
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
                                            child: Icon(Icons.local_library_sharp,size: 80,color: SecondaryColor,),
                                          ),
                                          SizedBox(height: 5,),
                                          Text("Your Selected Language",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 16,color: Colors.white),),
                                          SizedBox(height: 5,),
                                          Text(_locale.languageCode== "hi"? "HINDI":
                                          _locale.languageCode== "mr"? "Marathi".toUpperCase():
                                          _locale.languageCode== "gu"? "Gujarati".toUpperCase():
                                          _locale.languageCode== "ta"? "Tamil".toUpperCase():"English".toUpperCase(),style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                    left: 0,
                                    child: BackButton(
                                      color: SecondaryColor,
                                    ))

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.05),
                ),

                child: FlatButton(
                  splashColor: Colors.transparent,
                  hoverColor:Colors.transparent,
                  focusColor:Colors.transparent,
                  color:Colors.transparent,
                  highlightColor:Colors.transparent,
                  onPressed: (){
                    setState(() {
                    });
                    _changeLanguage(lang[0]);

                  },
                  child:Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            child:_locale.languageCode == "en" ?Icon(Icons.check_box,color: Colors.red,):
                            Icon(Icons.check_box_outline_blank)
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Text("English",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ) ,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.05),
                ),

                child: FlatButton(
                  splashColor: Colors.transparent,
                  hoverColor:Colors.transparent,
                  focusColor:Colors.transparent,
                  color:Colors.transparent,
                  highlightColor:Colors.transparent,
                  onPressed: (){

                    setState(() {
                    });
                    _changeLanguage(lang[1]);
                  },
                  child:Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            child: _locale.languageCode == "hi" ? Icon(Icons.check_box,color: Colors.red,):
                            Icon(Icons.check_box_outline_blank)
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Text("Hindi",style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ) ,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.05),
                ),

                child: FlatButton(
                  splashColor: Colors.transparent,
                  hoverColor:Colors.transparent,
                  focusColor:Colors.transparent,
                  color:Colors.transparent,
                  highlightColor:Colors.transparent,
                  onPressed: (){

                    setState(() {
                    });
                    _changeLanguage(lang[2]);
                  },
                  child:Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            child: _locale.languageCode == "mr" ? Icon(Icons.check_box,color: Colors.red,):
                            Icon(Icons.check_box_outline_blank)
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Text("Marathi",style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ) ,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.05),
                ),

                child: FlatButton(
                  splashColor: Colors.transparent,
                  hoverColor:Colors.transparent,
                  focusColor:Colors.transparent,
                  color:Colors.transparent,
                  highlightColor:Colors.transparent,
                  onPressed: (){

                    setState(() {
                    });
                    _changeLanguage(lang[3]);
                  },
                  child:Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            child: _locale.languageCode == "gu" ? Icon(Icons.check_box,color: Colors.red,):
                            Icon(Icons.check_box_outline_blank)
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Text("Gujarati",style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ) ,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.05),
                ),

                child: FlatButton(
                  splashColor: Colors.transparent,
                  hoverColor:Colors.transparent,
                  focusColor:Colors.transparent,
                  color:Colors.transparent,
                  highlightColor:Colors.transparent,
                  onPressed: (){

                    setState(() {

                    });
                    _changeLanguage(lang[4]);
                  },
                  child:Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            child: _locale.languageCode == 'ta' ? Icon(Icons.check_box,color: Colors.red,):
                            Icon(Icons.check_box_outline_blank)
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Text("Tamil",style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ) ,
                ),
              ),
            ],
          ),



        )
    );
  }
}
