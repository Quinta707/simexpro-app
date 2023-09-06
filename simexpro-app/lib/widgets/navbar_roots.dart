import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simexpro/screens/home_screen.dart';
import 'package:simexpro/screens/historial_screen.dart';
import 'package:simexpro/screens/settings_screen.dart';
import 'package:simexpro/widgets/OrdenesProduccion.dart';
import 'package:simexpro/screens/timeline_screen.dart';

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}
Future<void>Imagen() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  image =  prefs.getString('image');
}
class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    HomeScreen(),
    historialScreen(),
    TimelineScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Imagen();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(height: 35, image: NetworkImage('https://i.ibb.co/HgdBM0r/slogan.png')),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(image),
            
          ),
          )
          
        
          //  Positioned(
          //     top: .0,
          //     left: .0,
          //     right: 10,
          //     child: Center(
          //       child: CircleAvatar(
          //         radius: 20,
          //         backgroundImage: NetworkImage(image),
          //       ),
          //     ),
          //   )

          
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   tooltip: 'Ajustes',
          //   onPressed: () {},
          // ), 
        ], 
        backgroundColor: Color.fromRGBO(17, 24, 39, 1),
        elevation: 50.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menú',
          onPressed: () {},
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ), 
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(17, 24, 39, 1),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromRGBO(87, 69, 223, 1),
          unselectedItemColor: Colors.white,
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
                icon: Icon(Icons.timelapse_outlined), 
                label: "Rastreo"),
            
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), 
                label: "Ajustes"),
          ],
        ),
      ),
    );
  }
}
