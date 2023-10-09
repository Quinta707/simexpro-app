import 'package:flutter/material.dart';
import 'package:simexpro/widgets/concluded_historial.dart';
import 'package:simexpro/widgets/upcoming_historial.dart';
import 'package:simexpro/widgets/pending_historial.dart';


class historialScreen extends StatefulWidget {
  @override 
  State<historialScreen> createState() => _historialScreenState();
}

class _historialScreenState extends State<historialScreen> {
  int _buttonIndex = 0;

  final _historialWidgets = [
    Pendinghistorial(),
    Upcominghistorial(),
    Concludedhistorial(),
  ];
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
            child: Text(
              "Historial",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
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
                        "Pendientes",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 0 ? Colors.white : Colors.black38,
                        ),
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
                        "En proceso",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 1 ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _buttonIndex = 2;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      decoration: BoxDecoration(
                        color: _buttonIndex == 2
                            ? Color.fromRGBO(87, 69, 223, 1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Completadas",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 2 ? Colors.white : Colors.black38,
                        ),
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
