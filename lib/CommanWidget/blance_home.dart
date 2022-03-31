import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ThemeColor/Color.dart';

class BlanceHome extends StatelessWidget {

  final String balance;

  const BlanceHome({Key key, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container (
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(

                    child: Center(
                      child: (
                          Text(balance, style: TextStyle(fontSize: 12,color: TextColor),)
                      ),
                    ),
                  ),

                  Expanded(

                    child: Center(
                      child: (
                          Text('0.0', style: TextStyle(fontSize: 12,color: TextColor),)
                      ),
                    ),

                  ),

                  Expanded(

                    child: Center(
                      child: (
                          Text('0.0', style: TextStyle(fontSize: 12,color: TextColor),)
                      ),
                    ),

                  ),

                  Expanded(
                    child: Center(
                      child: (
                          Text('0.0', style: TextStyle(fontSize: 12,color: TextColor),)
                      ),
                    ),

                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(

                    child: Center(
                      child: (
                          Text('Wallet', style: TextStyle(fontSize: 10,color: TextColor),)
                      ),
                    ),

                  ),

                  Expanded(
                    child: Center(
                      child: (
                          Text('Credit', style: TextStyle(fontSize: 10,color: TextColor),)
                      ),
                    ),

                  ),

                  Expanded(

                    child: Center(
                      child: (
                          Text('Hold', style: TextStyle(fontSize: 10,color: TextColor),)
                      ),
                    ),

                  ),

                  Expanded(

                    child: Center(
                      child: (
                          Text('Total', style: TextStyle(fontSize: 10,color: TextColor),)
                      ),
                    ),

                  ),
                ],
              ),

            ],

          ),

        )
    );
  }
}

