import 'package:flutter/material.dart';
import 'package:simexpro/screens/lineatiempo.dart';
import 'package:simexpro/screens/maquinas_screen.dart';
import 'package:simexpro/screens/ordertracking/orders_screen.dart';
import 'package:simexpro/screens/prueba.dart';
import 'package:simexpro/toastconfig/toastconfig.dart';

class TimelineScreen extends StatelessWidget {
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
              "Líneas de tiempo",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(148, 82, 249, 1)
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
                      builder: (context) => MaquinasScreen(),
                ));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/logoMaquinas.png'),
                radius: 90,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('Máquinas',
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
                      builder: (context) => OrdersScreen(),
                ));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/logoOrdenes.png'),
                radius: 90,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('Órdenes',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
