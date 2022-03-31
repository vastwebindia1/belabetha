import 'package:flutter/material.dart';

class MyListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    final titles = ['Mobile', 'Dth', 'Land Line', 'Electricity',
      'Insurance', 'Gas', 'Water', 'Loan Emi', 'Broadband', 'FasTag'];

    final icons = [Icons.phone_android, Icons.phone_android,
      Icons.phone_missed_sharp, Icons.directions_car, Icons.directions_railway,
      Icons.directions_run, Icons.directions_subway, Icons.directions_transit,
      Icons.directions_walk, Icons.directions_transit];


    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: InkWell(onTap: (){



          },

            child: Container(
              width: 85.0,
              height: 20.0,
              child: Center(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(icons[index]),
                  ),
                  subtitle: Container(
                      alignment: Alignment.topCenter,
                      child: Text(titles[index],style: new TextStyle(fontSize: 12.0,color: Colors.purple),)),

                ),
              ),
            ),
          ),
        );
      },
    );
  }

  
}
