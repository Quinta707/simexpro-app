import 'package:flutter/material.dart';
import 'package:simexpro/screens/maquinas_screen.dart';
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
                backgroundImage: NetworkImage('https://i.ibb.co/VYPzhv8/MAQUINAS.png'),
                radius: 100,
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
                CherryToast.success(title: Text('Funciona', 
                style: TextStyle(color: Colors.white)),
                borderRadius: 0,
                ).show(context);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://i.ibb.co/vVz8MdF/ORDEN-1.png'),
                radius: 100,
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
