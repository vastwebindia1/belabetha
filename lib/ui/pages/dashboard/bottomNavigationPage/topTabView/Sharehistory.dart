// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class Printdata extends StatefulWidget {
  const Printdata({Key key, this.Number, this.amount, this.status, this.operator, this.optid, this.trnsid, this.date}) : super(key: key);
  final String Number;
  final String amount;
  final String status;
  final String operator;
  final String optid;
  final String trnsid;
  final String date;



  @override
  _PrintdataState createState() => _PrintdataState();
}

class _PrintdataState extends State<Printdata> {






  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Transaction Receipt")),
        body: PdfPreview(
          pdfPreviewPageDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: PrimaryColor,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(10)
            
          ),
          build: (format) => _generatePdf(format),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    Color spri = Colors.red;

    var img = await imageFromAssetBundle('assets/aashalogo.png');


    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [

              pw.SizedBox(
                height: 100,
                width: 100,
                child: pw.Image(img),
              ),

              pw.Text("Aasha Digital India",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 18,fontStyle: pw.FontStyle.italic)),

              pw.SizedBox(
                  height: 10
              ),

              pw.Container(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [

                        pw.Center(
                            child: pw.Container(
                                child: pw.Text("Transaction Receipt",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 30))
                            )
                        ),



                        pw.SizedBox(
                            height: 20
                        ),
                        pw.Container(
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Mobile Number : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.Number,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),
                        pw.SizedBox(
                            height: 10
                        ),

                        pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 2
                              )
                          ),
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Operator : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.operator,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),
                        pw.SizedBox(
                            height: 10
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 2
                              )
                          ),
                          child:  pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Status : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.status,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),
                        pw.SizedBox(
                            height: 10
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 2
                              )
                          ),
                          child:  pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Amount : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.amount,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),
                        pw.SizedBox(
                            height: 10
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 2
                              )
                          ),
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Txn Id : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.trnsid,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),

                        pw.SizedBox(
                            height: 10
                        ),

                        pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 2
                              )
                          ),
                          child:  pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Date : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.date,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),


                        pw.SizedBox(
                            height: 10
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(5),
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 2
                              )
                          ),
                          child:   pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [

                                pw.Text("Operator Id : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.optid,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                              ]
                          ),
                        ),


                      ]
                  )

              )

            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
