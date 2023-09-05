import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/settings_screen.dart';
import 'package:simexpro/widgets/OrdenesProduccion.dart';
import 'package:simexpro/screens/timeline_screen.dart';

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    Cartas(),
    historialScreen(),
    TimelineScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromRGBO(87, 69, 223, 1),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), 
                label: "Inicio"),
            
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), 
                label: "Historial"),

             BottomNavigationBarItem(
                icon: Icon(Icons.lock_clock_outlined), 
                label: "Líneas de tiempo"),
            
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), 
                label: "Configuración"),
          ],
        ),
      ),
    );
  }
}
