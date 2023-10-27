import 'package:flutter/material.dart';
import 'package:simexpro/widgets/concluded_historial.dart';
import 'package:simexpro/widgets/upcoming_historial.dart';
import 'package:simexpro/widgets/pending_historial.dart';

import '../widgets/concluded_historialAduana.dart';
import '../widgets/pending_historialAduana.dart';
import '../widgets/upcoming_historialAduana.dart';


class historialAduanaScreen extends StatefulWidget {
  @override 
  State<historialAduanaScreen> createState() => _historialAduanaScreenState();
}

class _historialAduanaScreenState extends State<historialAduanaScreen> {
  int _buttonIndex = 0;

  final _historialWidgets = [
    PendinghistorialAduana(),
    UpcominghistorialAduana(),
    ConcludedhistorialAduana(),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Historial Aduanero",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(99, 74, 158, 1)
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF4F6FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _buttonIndex = 0;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      decoration: BoxDecoration(
                        color: _buttonIndex == 0
                            ? Color.fromRGBO(87, 69, 223, 1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "DEVAS",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 0 ? Colors.white : Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _buttonIndex = 1;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      decoration: BoxDecoration(
                        color: _buttonIndex == 1
                            ? Color.fromRGBO(87, 69, 223, 1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "DUCAS",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 1 ? Colors.white : Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Widgets According to buttons
          _historialWidgets[_buttonIndex]
        ],
      ),
    ));
  }
}
