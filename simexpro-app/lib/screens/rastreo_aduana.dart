import 'package:flutter/material.dart';
import 'package:simexpro/screens/deva_screen.dart';
import 'package:simexpro/screens/lineatiempo.dart';
import 'package:simexpro/screens/ordertracking/orders_screen.dart';
import 'package:simexpro/screens/DUCA/duca_screen.dart';

class TimelineAduanaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Rastreo",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(99, 74, 158, 1)
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DevaScreen(),
                ));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/deva.png'),
                radius: 90,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('Declaraciones de valor',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
           Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DucasScreen(),
                ));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/duca.png'),
                radius: 90,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('DUCAS',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
