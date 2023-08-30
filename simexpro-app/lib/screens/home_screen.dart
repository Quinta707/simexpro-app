import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/screens/appointment_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:simexpro/widgets/chart_homescreen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bienvenido",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("images/doctor1.jpg"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Inicio",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 25,),
              ChartHomeScreen(),
            ],
          ),
        ),
      
    );
  }
}
