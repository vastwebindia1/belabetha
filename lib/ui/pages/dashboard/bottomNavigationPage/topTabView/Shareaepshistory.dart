// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class Printaepsdata extends StatefulWidget {
  const Printaepsdata({Key key, this.Number, this.amount, this.status, this.bnkname, this.txntype, this.trnsid, this.date, this.accno, this.aadharnum}) : super(key: key);
  final String Number;
  final String amount;
  final String status;
  final String bnkname;
  final String txntype;
  final String trnsid;
  final String date;
  final String accno;
  final String aadharnum;



  @override
  _PrintaepsdataState createState() => _PrintaepsdataState();
}

class _PrintaepsdataState extends State<Printaepsdata> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Transaction Detail")),
        body: PdfPreview(
          build: (format) => _generatePdf(format),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
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
                                child: pw.Text("AEPS HISTORY",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 30))
                            )
                        ),
                        pw.SizedBox(
                            height: 20
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

                                pw.Text("Bank Name : ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                               pw.Expanded(
                                 child:  pw.Text(widget.bnkname,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                               )
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

                                pw.Text("Bank ID: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.accno,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
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

                                pw.Text("Aadhar Number: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.aadharnum,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
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
                                pw.Expanded(
                                  child: pw.Text(widget.trnsid,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                )
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

                                pw.Text("Txn Type: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                                pw.Text(widget.txntype,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
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
